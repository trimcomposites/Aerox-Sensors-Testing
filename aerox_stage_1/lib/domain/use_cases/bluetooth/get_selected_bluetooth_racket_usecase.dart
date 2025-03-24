import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor_entity.dart';
import 'package:aerox_stage_1/domain/use_cases/use_case.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/bluetooth_repository.dart';

class GetSelectedBluetoothRacketUsecase extends AsyncUseCaseWithoutParams<RacketSensorEntity?> {
  
  const GetSelectedBluetoothRacketUsecase({ required this.bluetoothRepository });

  final BluetoothRepository bluetoothRepository;

  @override
  Future<EitherErr<RacketSensorEntity?>> call() {
    return bluetoothRepository.getSelectedRacketEntity();
  } 

}
