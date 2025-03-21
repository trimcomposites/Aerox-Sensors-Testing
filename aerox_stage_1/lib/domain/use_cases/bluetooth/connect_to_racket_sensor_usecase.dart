
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor_entity.dart';
import 'package:aerox_stage_1/domain/use_cases/use_case.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/bluetooth_repository.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ConnectToRacketSensorUsecase extends AsyncUseCaseWithParams<void,  RacketSensorEntity>{

  const ConnectToRacketSensorUsecase({ required this.bluetoothRepository  });

  final BluetoothRepository bluetoothRepository;

  @override
  Future<EitherErr<void>> call( RacketSensorEntity entity ) {
    
    final sensors = bluetoothRepository.connectRacketSensorEntity( entity );
    return sensors;

  } 


}