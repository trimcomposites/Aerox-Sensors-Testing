import 'dart:async';
import 'dart:typed_data';
import 'package:aerox_stage_1/common/utils/either_catch.dart';
import 'package:aerox_stage_1/common/utils/error/err/bluetooth_err.dart';
import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleService {
  Future<List<int>> sendCommand({
    required BluetoothDevice device,
    required Guid serviceUuid,
    required Guid characteristicUuid,
    required List<int> cmd,
    bool closeAfterResponse = true,
    bool requireStatusOk = true,
    bool reqOpCode = true
  }) async {
    final services = await device.discoverServices();
    final service = services.firstWhere((s) => s.uuid == serviceUuid, orElse: () {
      throw Exception("Service $serviceUuid not found");
    });

    final characteristic = service.characteristics.firstWhere(
      (c) => c.uuid == characteristicUuid,
      orElse: () => throw Exception("Characteristic $characteristicUuid not found"),
    );

    // Suscribirse primero y esperar respuesta filtrada
    final response = subscribeToCharacteristic(
      characteristic,
      expectedOpcode:
      reqOpCode
      ? cmd[0]
      : null,
      closeAfterFirst: closeAfterResponse,
      sentCommand: cmd,
      requireStatusOk: requireStatusOk,
      
    );

    await characteristic.write(cmd);
    print("Command sent: $cmd");

    final result = await response;
    if (result == null) throw Exception("No response received from device");

    return result ;
  }

 Future<List<int>?> subscribeToCharacteristic(
  BluetoothCharacteristic characteristic, {
  int? expectedOpcode, // 👈 puede ser null
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
      print("Expected opcode: $expectedOpcode");
      print("As Uint8List: ${Uint8List.fromList(value)}");

      final isEcho = sentCommand != null && _listsEqual(value, sentCommand);

      final isValidResponse = value.isNotEmpty &&
        (expectedOpcode == null || value[0] == expectedOpcode) && // 👈 acepta todo si es null
        (!requireStatusOk || (value.length > 1 && value[1] == 0x00));
        if (isValidResponse && !isEcho) {
          if (!completer.isCompleted) {
            completer.complete(value);

            if (closeAfterFirst) {
              try {
                final isConnected = await characteristic.device.connectionState.first == BluetoothConnectionState.connected;
                if (isConnected) {
                  await subscription?.cancel();
                  await characteristic.setNotifyValue(false);
                  print("🔕 Unsubscribed after matched value");
                }
              } catch (e) {
                print("⚠️ Error al cerrar notificaciones tras respuesta válida: $e");
              }
            }
          }


      } else {
        print("Ignored value: $value (echo: $isEcho, valid: $isValidResponse)");
      }
    });

    return await completer.future.timeout(
      const Duration(milliseconds: 1000),
      onTimeout: () {
        print("Timeout waiting for expected response (${expectedOpcode ?? 'any'})");
        return null;
      },
    );
  } catch (e) {
    print("Error subscribing to characteristic: $e");
    return null;
  }
}

Future<List<List<int>>> sendCommandAndCollectMultiple({
  required BluetoothDevice device,
  required Guid serviceUuid,
  required Guid characteristicUuid,
  required List<int> cmd,
  required bool Function(List<int> value) isValidResponse,
  int maxResponses = 10,
  Duration timeout = const Duration(seconds: 2),
}) async {
  final services = await device.discoverServices();
  final service = services.firstWhere((s) => s.uuid == serviceUuid);
  final characteristic = service.characteristics.firstWhere((c) => c.uuid == characteristicUuid);

  final completer = Completer<List<List<int>>>();
  final responses = <List<int>>[];
  late StreamSubscription<List<int>> subscription;

  bool isDone = false;

  await characteristic.setNotifyValue(true);

  subscription = characteristic.value.listen((value) async {
    if (isDone) return;

    if (isValidResponse(value)) {
      responses.add(value);
      if (responses.length >= maxResponses) {
        isDone = true;
        await subscription.cancel();
        await characteristic.setNotifyValue(false);
        if (!completer.isCompleted) completer.complete(responses);
      }
    }
  });

  await characteristic.write(cmd, withoutResponse: false);
  print("📤 Command sent: $cmd");

      Future.delayed(timeout).then((_) async {
        if (!isDone) {
          isDone = true;

          try {
            final isConnected = await characteristic.device.connectionState.first == BluetoothConnectionState.connected;
            if (isConnected) {
              await subscription.cancel();
              await characteristic.setNotifyValue(false);
            }
          } catch (e) {
            print("⚠️ Error al cancelar o desactivar notify tras timeout: $e");
          }

          if (!completer.isCompleted) {
            completer.complete(responses); 
          }
        }
});


  return completer.future;
}
Future<List<int>> sendCommandAndReadResponse({
  required BluetoothDevice device,
  required Guid serviceUuid,
  required Guid characteristicUuid,
  required List<int> cmd,
  Duration timeout = const Duration(seconds: 1),
}) async {
  final services = await device.discoverServices();
  final service = services.firstWhere((s) => s.uuid == serviceUuid);
  final characteristic = service.characteristics.firstWhere((c) => c.uuid == characteristicUuid);

  // write command
  await characteristic.write(cmd, withoutResponse: false);

  // read response directly
  return await characteristic.read().timeout(timeout);
}


  bool _listsEqual(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
