import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleService {
Future<List<int>?> sendCommand({
  required BluetoothDevice device,
  required Guid serviceUuid,
  required Guid characteristicUuid,
  required List<int> cmd,
  bool closeAfterResponse = true,
    bool requireStatusOk = true, 
}) async {
  try {
    final services = await device.discoverServices();
    final service = services.firstWhere((s) => s.uuid == serviceUuid);
    final characteristic = service.characteristics.firstWhere((c) => c.uuid == characteristicUuid);

    // Suscribirse primero y esperar respuesta filtrada
    final response = subscribeToCharacteristic(
      characteristic,
      expectedOpcode: cmd[0],
      closeAfterFirst: closeAfterResponse,
      sentCommand: cmd,
      requireStatusOk: requireStatusOk
    );

    // Enviar comando
    await characteristic.write(cmd);
    print("Command sent: $cmd");

    return await response;
  } catch (e) {
    print("Error sending command: $e");
    return null;
  }
}

Future<List<int>?> subscribeToCharacteristic(
  BluetoothCharacteristic characteristic, {
  required int expectedOpcode,
  List<int>? sentCommand,
  bool closeAfterFirst = true,
  bool requireStatusOk = true, 
}) async {
  try {
    final completer = Completer<List<int>?>();
    StreamSubscription<List<int>>? subscription;

    await characteristic.setNotifyValue(true);

    subscription = characteristic.value.listen((value) async {
      print("Received value: $value");
      print("Expected opcode: $expectedOpcode |");
      print("as Un8List, ${  Uint8List.fromList(value)}");
      
      final isEcho = sentCommand != null && _listsEqual(value, sentCommand);
      final isValidResponse = value.isNotEmpty &&
          value[0] == expectedOpcode &&
          (!requireStatusOk || (value.length > 1 && value[1] == 0x00));

      if (isValidResponse && !isEcho) {
        if (!completer.isCompleted) {
          completer.complete(value);
          if (closeAfterFirst) {
            await subscription?.cancel();
            await characteristic.setNotifyValue(false);
            print("Unsubscribed after matched value");
          }
        }
      } else {
        print("Ignored value: $value (echo: $isEcho, valid: $isValidResponse)");
      }
    });

    return await completer.future.timeout(
      const Duration(milliseconds: 500),
      onTimeout: () {
        print("Timeout waiting for expected response ($expectedOpcode)");
        return null;
      },
    );
  } catch (e) {
    print("Error subscribing to characteristic: $e");
    return null;
  }
}


bool _listsEqual(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

}