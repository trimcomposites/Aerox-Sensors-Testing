import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleService {
  Future<void> sendCommand({
    required BluetoothDevice device,
    required Guid serviceUuid,
    required Guid characteristicUuid,
    required int commandCode,
    required int sampleRate,
    required int inactivityTimeout,
  }) async {
    try {
      final services = await device.discoverServices();
      final service = services.firstWhere(
        (s) => s.uuid == serviceUuid,
      );

      final characteristic = service.characteristics.firstWhere(
        (c) => c.uuid == characteristicUuid,
      );

      int sampleRateData = 0;

      if( sampleRate == 1 ){
        sampleRateData = 0;
      }else if(sampleRate == 0x68 ){
        sampleRateData = 4;
      }

      final cmd = [
        commandCode, 
        sampleRateData,  
        1,
        6,
        6,
        inactivityTimeout
      ];

      await characteristic.write(cmd);
      print("Command sent: $cmd");

    } catch (e) {
      print("Error sending command: $e");
    }
  }





}
