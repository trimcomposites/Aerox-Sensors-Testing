import 'dart:async';

import 'package:aerox_stage_1/common/utils/either_catch.dart';
import 'package:aerox_stage_1/common/utils/error/err/bluetooth_err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor_extension.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/local/bluetooth_permission_handler.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
class BluetoothCustomService {
  final BluetoothPermissionHandler permissionHandler;
  bool _isScanning = false;
  final List<BluetoothDevice> _devices = [];
  StreamController<List<RacketSensor>>? _devicesStreamController;

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

  Future<EitherErr<Stream<List<RacketSensor>>>> startScan({String? filterName}) {
    return EitherCatch.catchAsync<Stream<List<RacketSensor>>, BluetoothErr>(() async {
      bool hasPermission = await checkPermissions();
      if (!hasPermission) {
        throw BluetoothErr(
          errMsg: 'No se puede iniciar el escaneo sin permisos.',
          statusCode: 403,
        );
      }
      
      if (_isScanning) return _devicesStreamController!.stream;
      _isScanning = true;
      _devices.clear();
    

    _devicesStreamController?.close();
    _devicesStreamController = StreamController<List<RacketSensor>>.broadcast();

      if (FlutterBluePlus.adapterStateNow != BluetoothAdapterState.on) {
        print("⛔ Bluetooth no está encendido. Esperando...");
        await FlutterBluePlus.adapterState.firstWhere(
          (state) => state == BluetoothAdapterState.on,
        );
        print("Iniciando escaneo... ${ filterName }");
      }

      FlutterBluePlus.startScan();

      FlutterBluePlus.scanResults.listen((results) async {
        bool hasChanged = false;

      for (ScanResult result in results) {
        String deviceName = (result.device.platformName ?? '').toLowerCase();
        String localName = (result.device.localName ?? '').toLowerCase();
        String? filter = filterName?.toLowerCase();

        if (filter == null || deviceName.contains(filter) || localName.contains(filter)) {
          if (!_devices.any((d) => d.remoteId == result.device.remoteId)) {
            _devices.add(result.device);
            hasChanged = true;
          }
        }
      }
      //addFakeDevices();

        if (hasChanged) {
          List<RacketSensor> racketSensors = await Future.wait(
            _devices.map((device) async => await device.toRacketSensor( state:  await device.connectionState.first))
          );

          _devicesStreamController?.add(racketSensors);
        }
      });

      print("Escaneo iniciado. ${filterName} ");
      return _devicesStreamController!.stream;
    }, (exception) {
      throw BluetoothErr(
        errMsg: 'Error iniciando el escaneo: ${exception.toString()}',
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

    List<BluetoothDevice> devicesCopy = List.from(_devices);

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



}
