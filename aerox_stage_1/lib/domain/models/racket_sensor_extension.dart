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
        name: platformName.isNotEmpty ? platformName : customName ?? remoteId.toString(),
        id: remoteId.toString(),
        connectionState: state,
      );
  }

}
