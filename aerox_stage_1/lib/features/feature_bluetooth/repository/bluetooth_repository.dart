import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/local/racket_bluetooth_service.dart';

class BluetoothRepository {

  final RacketBluetoothService bluetoothService;

  BluetoothRepository({required this.bluetoothService});


  Future<EitherErr<List<RacketSensor>>> scanAllRacketDevices() async {
      
      return await bluetoothService.scanAllRacketDevices();
    } 

}
