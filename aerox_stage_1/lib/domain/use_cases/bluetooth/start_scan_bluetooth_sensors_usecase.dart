
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/domain/use_cases/use_case.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/bluetooth_repository.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class StartScanBluetoothSensorsUsecase extends AsyncUseCaseWithoutParams<Stream<List<RacketSensor>>>{

  const StartScanBluetoothSensorsUsecase({ required this.bluetoothRepository  });

  final BluetoothRepository bluetoothRepository;

  @override
  Future<EitherErr<Stream<List<RacketSensor>>>> call() {
    
    final sensors = bluetoothRepository.startSensorsScan( );
    return sensors;

  } 


}