import 'dart:async';

import 'package:aerox_stage_1/common/utils/either_catch.dart';
import 'package:aerox_stage_1/common/utils/error/err/bluetooth_err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor_extension.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';


class BluetoothCustomService {
  
  bool _isScanning = false;
  final List<BluetoothDevice> _devices = [];
StreamController<List<RacketSensor>>? _devicesStreamController; 


  Future<EitherErr<Stream<List<RacketSensor>>>> startScan({String? filterName})  {
    return EitherCatch.catchAsync<Stream<List<RacketSensor>>, BluetoothErr>(() async {
      if (_isScanning) return _devicesStreamController!.stream;
      _isScanning = true;
      _devicesStreamController = StreamController<List<RacketSensor>>.broadcast();

      if (FlutterBluePlus.adapterStateNow != BluetoothAdapterState.on) {
        print("⛔ Bluetooth no está encendido. Esperando...");
        await FlutterBluePlus.adapterState.firstWhere(
          (state) => state == BluetoothAdapterState.on,
        );
        print("Iniciando escaneo...");
      }

      FlutterBluePlus.startScan();

      FlutterBluePlus.scanResults.listen((results) async {
        bool hasChanged = false;

        for (ScanResult result in results) {
          if (filterName == null || result.device.platformName.contains(filterName)) {
            if (!_devices.any((d) => d.remoteId == result.device.remoteId)) {
              _devices.add(result.device);
              hasChanged = true;
            }
          }
        }


    if (hasChanged) {
      List<RacketSensor> racketSensors = await Future.wait(
        _devices.map((device) async => await device.toRacketSensor(await device.connectionState.first))
      );

      _devicesStreamController?.add(racketSensors);
    }});
      print("Escaneo iniciado.");
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



}
