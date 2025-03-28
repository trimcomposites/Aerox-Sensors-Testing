import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/local/bluetooth_permission_handler.dart';



void main() {
  late BluetoothPermissionHandler permissionHandler;

  setUp(() {
    permissionHandler = BluetoothPermissionHandler();
  });

  group('BluetoothPermissionHandler', () {
    test('hasPermissions returns true on non-Android platforms', () async {
      final isAndroid = Platform.isAndroid;
      if (!isAndroid) {
        final result = await permissionHandler.hasPermissions();
        expect(result, true);
      }
    });

    test('requestPermissions does not throw on non-Android platforms', () async {
      final isAndroid = Platform.isAndroid;
      if (!isAndroid) {
        await permissionHandler.requestPermissions();
        expect(true, true); 
      }
    });

  });
}
