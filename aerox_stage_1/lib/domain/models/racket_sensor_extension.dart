import 'package:aerox_stage_1/common/utils/either_catch.dart';
import 'package:aerox_stage_1/common/utils/error/err/bluetooth_err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

extension RacketSensorExtension on BluetoothDevice {
  /// Convert a BluetoothDevice into a RacketSensor con manejo de errores
  RacketSensor toRacketSensor({required  BluetoothConnectionState state, String? customName }) {
      return RacketSensor(
        device: this,
        position: getProvisionalSensorPosition(this),
        name: customName ?? this.platformName?? remoteId.toString(),
        id: remoteId.toString(),
        connectionState: state,
      );
  }

SensorPosition getProvisionalSensorPosition(BluetoothDevice device) {
  print(device.remoteId.str);
  switch (device.remoteId.str) {
    case 'FB6BD1C5-1C3C-29C3-53DB-8C899D7F817B':
      return SensorPosition.left;
    case '4DA3A35D-2605-51E2-DF3A-B6FEB3E48666':
      return SensorPosition.right;
    case '2558C219-26E1-5D9C-A262-D0485D3F1F18':
      return SensorPosition.down;
    case '6B967F20-F374-20B4-9C0F-CFC09623572E':
      return SensorPosition.up;
    default:
      return SensorPosition.down; 
  }
  }
}


enum SensorPosition {
  up,
  down,
  left,
  right
}