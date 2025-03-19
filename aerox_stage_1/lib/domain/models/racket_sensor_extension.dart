import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

extension RacketSensorExtension on BluetoothDevice {
  /// Convert a BluetoothDevice into a RacketSensor
  Future<RacketSensor> toRacketSensor() async {
    BluetoothConnectionState state = await connectionState.first; 

    return RacketSensor(
      device: this, 
      name: platformName.isNotEmpty ? platformName : "Unknown Racket Sensor",
      id: remoteId.toString(),
      connectionState: state,
    );
  }
}
