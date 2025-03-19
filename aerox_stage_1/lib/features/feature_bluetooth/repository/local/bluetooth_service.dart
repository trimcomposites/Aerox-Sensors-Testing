import 'dart:async';

import 'package:aerox_stage_1/common/utils/either_catch.dart';
import 'package:aerox_stage_1/common/utils/error/err/bluetooth_err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';


class BluetoothCustomService {
  

  Future<EitherErr<List<BluetoothDevice>>> scanDevices({String? filterName}) async {
    return EitherCatch.catchAsync<List<BluetoothDevice>, BluetoothErr>(() async {
      List<BluetoothDevice> devices = [];
      final Completer<void> scanComplete = Completer<void>();

      if (FlutterBluePlus.adapterStateNow != BluetoothAdapterState.on) {
        print("⛔ Bluetooth no está encendido. Esperando...");
        await FlutterBluePlus.adapterState.firstWhere(
          (state) => state == BluetoothAdapterState.on,
        );
        print("✅ Bluetooth encendido. Iniciando escaneo...");
      }

      // 📡 Iniciar escaneo
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

      // 🔄 Capturar dispositivos encontrados
      final subscription = FlutterBluePlus.scanResults.listen((results) {
        for (ScanResult result in results) {
          if (filterName == null || result.device.platformName.contains(filterName)) {
            if (!devices.any((d) => d.remoteId == result.device.remoteId)) {
              devices.add(result.device);
            }
          }
        }
      });

      // ⏳ Esperar el tiempo de escaneo antes de detenerlo
      await Future.delayed(const Duration(seconds: 5));
      await FlutterBluePlus.stopScan();

      // ✅ Cancelar la suscripción al Stream
      await subscription.cancel();
      scanComplete.complete();

      // 🔄 Esperar a que el escaneo finalice antes de retornar
      await scanComplete.future;

      print("✅ Escaneo completado. ${devices.length} dispositivos encontrados.");
      return devices;
    }, (exception) {
      return BluetoothErr(
        errMsg: 'Error scanning devices: ${exception.toString()}',
        statusCode: 500,
      );
    });
  }
  /// 🔗 Connect to a Bluetooth device
  Future<EitherErr<void>> connectToDevice(BluetoothDevice device) async {
    return EitherCatch.catchAsync<void, BluetoothErr>(() async {
      await device.connect();
      print("Connected to ${device.platformName}");
    }, (exception) {
      return BluetoothErr(
        errMsg: 'Error connecting to ${device.platformName}: ${exception.toString()}',
        statusCode: 500,
      );
    });
  }

  /// 🔍 Discover services and characteristics
  Future<EitherErr<List<BluetoothService>>> discoverServices(BluetoothDevice device) async {
    return EitherCatch.catchAsync<List<BluetoothService>, BluetoothErr>(() async {
      List<BluetoothService> services = await device.discoverServices();
      print("Discovered ${services.length} services on ${device.platformName}");
      return services;
    }, (exception) {
      return BluetoothErr(
        errMsg: 'Error discovering services on ${device.platformName}: ${exception.toString()}',
        statusCode: 500,
      );
    });
  }

  Future<EitherErr<List<int>>> readCharacteristic(BluetoothCharacteristic characteristic) async {
    return EitherCatch.catchAsync<List<int>, BluetoothErr>(() async {
      List<int> value = await characteristic.read();
      print("Data read: $value");
      return value;
    }, (exception) {
      return BluetoothErr(
        errMsg: 'Error reading characteristic: ${exception.toString()}',
        statusCode: 500,
      );
    });
  }

  Future<EitherErr<void>> listenToCharacteristic(BluetoothCharacteristic characteristic) async {
    return EitherCatch.catchAsync<void, BluetoothErr>(() async {
      await characteristic.setNotifyValue(true);
      characteristic.value.listen((value) {
        print("Notification received: $value");
      });
    }, (exception) {
      return BluetoothErr(
        errMsg: 'Error listening to characteristic: ${exception.toString()}',
        statusCode: 500,
      );
    });
  }
  void monitorConnection(BluetoothDevice device) {
    device.connectionState.listen((state) {
      print("Connection state of ${device.platformName}: $state");
    });
  }
}
