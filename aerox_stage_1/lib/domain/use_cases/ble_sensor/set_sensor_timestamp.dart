
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/blob.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/domain/use_cases/use_case.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/ble_repository.dart';

class SetSensorTimestamp extends AsyncUseCaseWithParams<void,  RacketSensor>{

  final BleRepository bleRepository;

  SetSensorTimestamp({required this.bleRepository});
  @override
  Future<EitherErr<List<Blob>>> call( sensor ) async {
    
    final blobs = bleRepository.readAllBlobs( sensor );
    return blobs;

  } 


}