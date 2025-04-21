
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor_entity.dart';
import 'package:aerox_stage_1/domain/use_cases/use_case.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_rtsos_hs/ui/rtsos_record_params_widget.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/ble_repository.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/bluetooth_repository.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class StartOfflineRTSOSUseCase extends AsyncUseCaseWithParams<void,  StartRTSOSParams>{

  final BleRepository bleRepository;

  StartOfflineRTSOSUseCase({required this.bleRepository});
  @override
  Future<EitherErr<void>> call( params ) {
    
    final response = bleRepository.sendStartOfflineRSTOS( params );
    return response;

  } 


}
enum SampleRate{
  khz1,
  hz104
}
class StartRTSOSParams{
  final SampleRate sampleRate;
  final int durationSeconds;
  final RacketSensor sensor;

  StartRTSOSParams({required this.sampleRate, required this.durationSeconds, required this.sensor });
}