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

// void addFakeDevices() {
//   // Mapa de direcciones MAC simuladas y sus nombres correspondientes
//   final Map<String, String> fakeDevices = {
//     "00:11:22:33:44:55": "SmartInsole123",
//     "00:11:22:33:44:42": "SmartInsole123",
//     "00:11:22:33:22:55": "Altavoz Falso",
//     "66:77:88:99:AA:BB": "Auriculares Falsos",
//     "CC:DD:EE:FF:00:11": "Controlador de Juego Falso",
//   };

//   // Crear y agregar dispositivos falsos a la lista `_devices`
//   fakeDevices.forEach((mac, name) {
//     final device = BluetoothDevice(remoteId: DeviceIdentifier(mac));
//         if (name.contains('SmartInsole') ) {
//           //if (!_devices.any((d) => d.remoteId == device.remoteId)) {
//             _devices.add(device);
//           //}
//         }
//     print("Dispositivo falso agregado: $name con MAC $mac");
//   });

//   // Notificar al Stream que hay nuevos dispositivos falsos
//   Future.delayed(Duration(seconds: 1), () async {
//     final racketSensors = await Future.wait(
//       _devices.map((device) async {
//         final name = fakeDevices[device.remoteId.toString()] ?? "Dispositivo Desconocido";
//         return await device.toRacketSensor( state: await device.connectionState.first, customName: name);
//       }),
//     );
//     _devicesStreamController?.add(racketSensors);
//   });
// }

}
