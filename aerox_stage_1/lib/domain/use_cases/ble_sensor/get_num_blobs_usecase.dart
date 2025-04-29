
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/blob.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/domain/use_cases/use_case.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/ble_repository.dart';

class GetNumBlobsUsecase extends AsyncUseCaseWithParams<void,  RacketSensor>{

  final BleRepository bleRepository;

  GetNumBlobsUsecase({required this.bleRepository});
  @override
  Future<EitherErr<int>> call( sensor ) async {
    
    return bleRepository.getSensorNumBlobs( sensor );


  } 


}