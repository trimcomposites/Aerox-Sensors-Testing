import 'package:aerox_stage_1/common/utils/either_catch.dart';
import 'package:aerox_stage_1/common/utils/error/err/bluetooth_err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

extension RacketSensorExtension on BluetoothDevice {
  /// Convert a BluetoothDevice into a RacketSensor con manejo de errores
  RacketSensor toRacketSensor( BluetoothConnectionState state ) {
      return RacketSensor(
        device: this,
        name: platformName.isNotEmpty ? platformName : "Unknown Racket Sensor",
        id: remoteId.toString(),
        connectionState: state,
      );
  }

}
