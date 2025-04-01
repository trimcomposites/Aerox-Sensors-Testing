import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleService {
  Future<void> sendCommand({
    required BluetoothDevice device,
    required Guid serviceUuid,
    required Guid characteristicUuid,
    required List<int> cmd,
  }) async {
    try {
      final services = await device.discoverServices();
      final service = services.firstWhere(
        (s) => s.uuid == serviceUuid,
      );

      final characteristic = service.characteristics.firstWhere(
        (c) => c.uuid == characteristicUuid,
      );

      await characteristic.write(cmd);
      print("Command sent: $cmd");


      await subscribeToCharacteristic(characteristic); 
      

    } catch (e) {
      print("Error sending command: $e");
    }
  }

  Future<void> subscribeToCharacteristic(BluetoothCharacteristic characteristic) async {
    try {
      await characteristic.setNotifyValue(true);

      characteristic.value.listen((value) {
        print("Received value: $value");
      });

      print("Subscribed to characteristic notifications");

    } catch (e) {
      print("Error subscribing to characteristic: $e");
    }
  }
}
