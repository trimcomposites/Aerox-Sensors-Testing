import 'package:aerox_stage_1/common/utils/either_catch.dart';
import 'package:aerox_stage_1/common/utils/error/err/bluetooth_err.dart';
import 'package:aerox_stage_1/common/utils/error/err/comment_err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor_entity.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor_extension.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/local/bluetooth_service.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class RacketBluetoothService {

  final BluetoothCustomService bluetoothService;

  RacketBluetoothService({required this.bluetoothService});

Future<EitherErr<Stream<List<RacketSensorEntity>>>> scanAllRacketDevices() {
    return bluetoothService.startScan(filterName: 'SmartInsole').then(
      (result) => result.map((stream) => groupSensorsByNameStream(stream)),
    );
  }

  Stream<List<RacketSensorEntity>> groupSensorsByNameStream(Stream<List<RacketSensor>> stream) {
    return stream.map((sensors) {
      List<RacketSensorEntity> entities = [];
      for (var sensor in sensors) {
        var existingEntity = entities.firstWhere(
          (entity) => entity.name == sensor.name,
          orElse: () => RacketSensorEntity(name: sensor.name, id: sensor.id, sensors: []),
        );
        if (!entities.contains(existingEntity)) {
          entities.add(existingEntity);
        }
        existingEntity.sensors.add(sensor);
      }
      return entities;
    });
  }
  Future<EitherErr<void>> stopScanRacketDevices() {
    return bluetoothService.stopScan();
  }

  Future<EitherErr<void>> connectRacketSensorEntity(RacketSensorEntity entity) async {
    final sensors = entity.sensors;

    for (RacketSensor sensor in sensors) {
      final result = await bluetoothService.connectToDevice(sensor);
      if (result.isLeft()) {
        return result;
      }
    }

    return Right(null);
  }

  Future<EitherErr<void>> disconnectRacketSensorEntity(RacketSensorEntity entity) async {
    final sensors = entity.sensors;

    for (RacketSensor sensor in sensors) {
      final result = await bluetoothService.disconnectFromDevice(sensor);
      if (result.isLeft()) {
        return result; 
      }
    }

    return Right(null); 
  }
  Future<EitherErr<RacketSensorEntity?>> getConnectedRacketEntity() async {
    return bluetoothService.getConnectedSensors().then((result) {
      return result.map((connectedSensors) {
        if (connectedSensors.isEmpty) {
          return null;
        }
        String entityName = connectedSensors.first.name;
        String entityId = connectedSensors.first.id;
        return RacketSensorEntity(name: entityName, id: entityId, sensors: connectedSensors);
      });
    });
  }


}