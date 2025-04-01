
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor_entity.dart';
import 'package:aerox_stage_1/domain/use_cases/use_case.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/ble_repository.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/bluetooth_repository.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ReadStorageDataUsecase extends AsyncUseCaseWithParams<void,  RacketSensor>{

  final BleRepository bleRepository;

  ReadStorageDataUsecase({required this.bleRepository});
  @override
  Future<EitherErr<void>> call( sensor ) {
    
    final sensors = bleRepository.readData( sensor );
    return sensors;

  } 


}