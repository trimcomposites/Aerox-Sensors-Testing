import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/local/ble_service.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/local/bluetooth_service.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleRepository {

  final BleService bleService;

  BleRepository({required this.bleService});

  
  Future<EitherErr<void>> sendStartOfflineRSTOS(RacketSensor sensor) async {
  
    final serviceUuid = Guid('71d713ef-799e-42af-9d57-9803e36b0f93'); 
    final characteristicUuid = Guid('a84ce035-60ed-4b24-99c9-8683052aa48b'); 
    
    final commandCode = 0x22; 
    final sampleRate = 0x68; 
    final inactivityTimeout = 0x0A; 
   
    await bleService.sendCommand(
      device: sensor.device,
      serviceUuid: serviceUuid,
      characteristicUuid: characteristicUuid,
      commandCode: commandCode,
      sampleRate: sampleRate,  
      inactivityTimeout: inactivityTimeout,  

    );

    return Right(null);
  }

  Future<EitherErr<void>> sendStoptOfflineRSTOS(RacketSensor sensor) async {
    
    final serviceUuid = Guid('71d713ef-799e-42af-9d57-9803e36b0f93'); 
    final characteristicUuid = Guid('a84ce035-60ed-4b24-99c9-8683052aa48b');  
    
    final commandCode = 0x2F; 
    final sampleRate = 0x68;
    final inactivityTimeout = 0x0A; 

    await bleService.sendCommand(
      device: sensor.device,
      serviceUuid: serviceUuid,
      characteristicUuid: characteristicUuid,
      commandCode: commandCode,
      sampleRate: sampleRate,  
      inactivityTimeout: inactivityTimeout,  
    );

    return Right(null);
  }
}