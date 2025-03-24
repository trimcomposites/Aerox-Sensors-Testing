import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor_entity.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/local/racket_bluetooth_service.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothRepository {

  final RacketBluetoothService bluetoothService;

  BluetoothRepository({required this.bluetoothService});


  Future<EitherErr<Stream<List<RacketSensorEntity>>>> startSensorsScan() async {
      
      return await bluetoothService.scanAllRacketDevices();
    } 
  Future<EitherErr<void>> stopSensorsScan() async {
      
      return await bluetoothService.stopScanRacketDevices();
    }

  Future<EitherErr<void>> connectRacketSensorEntity( RacketSensorEntity entity ) async {
    return await bluetoothService.connectRacketSensorEntity( entity );
  } 
  Future<EitherErr<void>> disconnectRacketSensorEntity( RacketSensorEntity entity ) async {
    return await bluetoothService.disconnectRacketSensorEntity( entity );
  } 
  Future<EitherErr<void>> reScan() async {
    return await bluetoothService.reScan();
  } 
  Future<EitherErr<RacketSensorEntity?>> getSelectedRacketEntity( ) async {
    return await bluetoothService.getConnectedRacketEntity( );
  } 

}
