import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:aerox_stage_1/common/utils/either_catch.dart';
import 'package:aerox_stage_1/common/utils/error/err/bluetooth_err.dart';
import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor_extension.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/local/bluetooth_permission_handler.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
class BluetoothCustomService {
  final BluetoothPermissionHandler permissionHandler;
  bool _isScanning = false;
  List<BluetoothDevice> devices = [];
  StreamController<List<RacketSensor>>? _devicesStreamController;
  bool isRestartingScan = false;
  StreamSubscription? scanSubscription;
  BluetoothCustomService({ required this.permissionHandler });

  Future<bool> checkPermissions() async {
    if (await permissionHandler.hasPermissions()) {
      print("Permisos concedidos");
      return true;
    } else {
      print("Permisos denegados");
      await permissionHandler.requestPermissions();
      return false;
    }
  }
Future<EitherErr<Stream<List<RacketSensor>>>> startScan({
  String? filterName,
  List<String>? filterNames,
}) {
  return EitherCatch.catchAsync<Stream<List<RacketSensor>>, BluetoothErr>(() async {
    bool hasPermission = await checkPermissions();
    if (!hasPermission) {
      throw BluetoothErr(
        errMsg: 'No se puede iniciar el escaneo sin permisos.',
        statusCode: 403,
      );
    }

    // Construimos el set de keywords (minúsculas, sin vacíos)
    final Set<String> keywords = {
      if (filterName != null && filterName.trim().isNotEmpty) filterName.trim().toLowerCase(),
      ...((filterNames ?? const <String>[])
          .map((s) => s.trim().toLowerCase())
          .where((s) => s.isNotEmpty)),
    };

    // Si ya hay escaneo en curso, devolvemos el stream existente
    if (_isScanning && _devicesStreamController != null) {
      return _devicesStreamController!.stream;
    }

    _isScanning = true;

    _devicesStreamController?.close();
    _devicesStreamController = StreamController<List<RacketSensor>>.broadcast();

    if (FlutterBluePlus.adapterStateNow != BluetoothAdapterState.on) {
      print("⛔ Bluetooth no está encendido. Esperando...");
      await FlutterBluePlus.adapterState.firstWhere(
        (state) => state == BluetoothAdapterState.on,
      );
    }

    // Inicia el escaneo (sin filtro de lib; filtramos nosotros)
    FlutterBluePlus.startScan();

    scanSubscription = FlutterBluePlus.onScanResults.listen((results) async {
      final detectedDevices = results.map((r) => r.device).toList();

      // Copia segura + purga de dispositivos no vistos y no conectados
      final currentDevices = List<BluetoothDevice>.from(devices);
      final updatedDevices = <BluetoothDevice>[];

      for (final device in currentDevices) {
        final isStillDetected = detectedDevices.any((d) => d.remoteId == device.remoteId);
        final isConnected = await device.connectionState.first == BluetoothConnectionState.connected;

        if (isStillDetected || isConnected) {
          updatedDevices.add(device);
        }
      }

      devices
        ..clear()
        ..addAll(updatedDevices);

      // Añadir nuevos dispositivos que cumplan con el filtro (si existe)
      for (final result in results) {
        final String name  = (result.device.platformName ?? '').toLowerCase();
        final String local = (result.device.localName ?? '').toLowerCase();

        final bool passesFilter = keywords.isEmpty
            ? true
            : keywords.any((kw) => name.contains(kw) || local.contains(kw));

        if (passesFilter) {
          if (!devices.any((d) => d.remoteId == result.device.remoteId)) {
            devices.add(result.device);
          }
        }
      }

      // Mapear a tu entidad
      final racketSensors = await Future.wait(
        devices.map((device) async {
          final state = await device.connectionState.first;
          return await device.toRacketSensor(state: state);
        }),
      );

      _devicesStreamController?.add(racketSensors);
    });

    print("🔍 Escaneo iniciado | keywords: ${keywords.isEmpty ? '(abierto)' : keywords.join(', ')}");
    return _devicesStreamController!.stream;
  }, (exception) {
    throw BluetoothErr(
      errMsg: 'Error iniciando el escaneo: ${exception.toString()}',
      statusCode: 500,
    );
  });
}



Future<EitherErr<void>> reScan() {
  return EitherCatch.catchAsync<void, BluetoothErr>(() async {
    if (!_isScanning || isRestartingScan) return;

    isRestartingScan = true;

    if (_isScanning) { 
      await FlutterBluePlus.stopScan();
      await Future.delayed(Duration(milliseconds: 500));
      FlutterBluePlus.startScan();
    }

    isRestartingScan = false;
  }, (exception) {
    return BluetoothErr(
      errMsg: 'Error reiniciando el escaneo: ${exception.toString()}',
      statusCode: 500,
    );
  });
}

  Future<EitherErr<void>> stopScan() {
    return EitherCatch.catchAsync<void, BluetoothErr>(() async {
      if (!_isScanning) return;
      _isScanning = false;

      await FlutterBluePlus.stopScan();
      _devicesStreamController?.close();
      _devicesStreamController = null;
      scanSubscription!.cancel();
      print("Escaneo stopped.");
    }, (exception) {
      throw BluetoothErr(
        errMsg: 'Error deteniendo el escaneo: ${exception.toString()}',
        statusCode: 500,
      );
    });
  }

  Future<EitherErr<void>> connectToDevice(RacketSensor racketSensor) async {
    return EitherCatch.catchAsync<void, BluetoothErr>(() async {
      await racketSensor.device.connect();
      //await racketSensor.device.requestMtu(247); // máximo recomendado

      print("Connected to ${racketSensor.name}");
    }, (exception) {
      return BluetoothErr(
        errMsg: 'Error connecting to ${racketSensor.name}: ${exception.toString()}',
        statusCode: 500,
      );
    });
  }
  Future<EitherErr<void>> disconnectFromDevice(RacketSensor racketSensor) async {
    return EitherCatch.catchAsync<void, BluetoothErr>(() async {
      if (racketSensor.device.isConnected) {
        await racketSensor.device.disconnect();
        print("Disconnected from ${racketSensor.name}");
      } else {
        print("${racketSensor.name} ya está desconectado.");
      }
    }, (exception) {
      return BluetoothErr(
        errMsg: 'Error desconectando de ${racketSensor.name}: ${exception.toString()}',
        statusCode: 500,
      );
    });
  }
Future<EitherErr<List<RacketSensor>>> getConnectedSensors() async {
  return EitherCatch.catchAsync<List<RacketSensor>, BluetoothErr>(() async {
    List<RacketSensor> connectedSensors = [];

    List<BluetoothDevice> devicesCopy = List.from(devices);

    for (BluetoothDevice device in devicesCopy) {
      BluetoothConnectionState state = await device.connectionState.first;
      if (state == BluetoothConnectionState.connected) {
        connectedSensors.add(await device.toRacketSensor(state: state));
      }
    }

    return connectedSensors;
  }, (exception) {
    return BluetoothErr(
      errMsg: 'Error obteniendo sensores conectados: ${exception.toString()}',
      statusCode: 500,
    );
  });
  
}

Future<Either<Err, Stream<List<int>>>> subscribeToCharacteristic({
    required BluetoothDevice device,
    required Guid serviceUuid,
    required Guid characteristicUuid,
  }) {
    return EitherCatch.catchAsync<Stream<List<int>>, BluetoothErr>(
      () async {
        final services = await device.discoverServices();
        final targetService = services.firstWhere(
          (service) => service.uuid == serviceUuid,
          orElse: () => throw BluetoothErr(
            errMsg: 'Service no encontrado con UUID: $serviceUuid',
            statusCode: 404,
          ),
        );

        final targetCharacteristic = targetService.characteristics.firstWhere(
          (char) => char.uuid == characteristicUuid,
          orElse: () => throw BluetoothErr(
            errMsg: 'Characteristic no encontrada con UUID: $characteristicUuid',
            statusCode: 404,
          ),
        );

        await targetCharacteristic.setNotifyValue(true);

        return targetCharacteristic.onValueReceived;
      },
      (exception) => BluetoothErr(
        errMsg: 'Error al suscribirse a la característica: ${exception.toString()}',
        statusCode: 500,
      ),
    );
  }

}
