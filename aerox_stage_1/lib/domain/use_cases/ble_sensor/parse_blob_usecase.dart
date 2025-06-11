
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/blob.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/domain/use_cases/use_case.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/ble_repository.dart';

class ParseBlobUsecase extends AsyncUseCaseWithParams<List<Map<String, dynamic>>,  Blob>{

  final BleRepository bleRepository;

  ParseBlobUsecase({required this.bleRepository});
  @override
  Future<EitherErr<List<Map<String, dynamic>>>> call( blob ) async {
    
    final parsed = await bleRepository.parseBlob(  blob );
    return parsed;

  } 


}