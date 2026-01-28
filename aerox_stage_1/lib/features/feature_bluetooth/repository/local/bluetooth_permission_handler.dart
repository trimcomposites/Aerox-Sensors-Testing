import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

import 'package:location/location.dart';

class BluetoothPermissionHandler {
  final Location _location = Location();

  Future<bool> hasPermissions() async {
    if (Platform.isAndroid) {
      final scanGranted = await Permission.bluetoothScan.isGranted;
      final connectGranted = await Permission.bluetoothConnect.isGranted;
      final locationGranted = await Permission.location.isGranted;

      final serviceEnabled = await _location.serviceEnabled();

      return scanGranted && connectGranted && locationGranted && serviceEnabled;
    } else {
      return true;
    }
  }

  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      await Permission.bluetooth.request();
      await Permission.bluetoothScan.request();
      await Permission.bluetoothConnect.request();
      await Permission.location.request();

      final serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        final enabled = await _location.requestService();
        if (!enabled) {
          print('⚠️ El usuario no activó el GPS.');
        }
      }
    }
  }
}
