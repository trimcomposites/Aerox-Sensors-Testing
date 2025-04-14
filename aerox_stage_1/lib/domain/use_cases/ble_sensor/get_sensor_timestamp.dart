
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/blob.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/domain/use_cases/use_case.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/ble_repository.dart';

class GetSensorTimestampUseCase extends AsyncUseCaseWithParams<void,  RacketSensor>{

  final BleRepository bleRepository;

  GetSensorTimestampUseCase({required this.bleRepository});
  @override
  Future<EitherErr<void>> call( sensor ) async {
    
    return bleRepository.getTimestamp( sensor );


  } 


}