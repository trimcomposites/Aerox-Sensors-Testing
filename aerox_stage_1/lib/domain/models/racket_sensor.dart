import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class RacketSensor {
  final BluetoothDevice device;
  String name;
  String alias;
  String id;
  BluetoothConnectionState connectionState;
  List<BluetoothService> services = [];
  Map<String, BluetoothCharacteristic> characteristics = {};

  RacketSensor({
    required this.device,
    required this.name,
    required this.alias,
    required this.id,
    required this.connectionState,
  });

}
