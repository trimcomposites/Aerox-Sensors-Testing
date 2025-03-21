import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class BluetoothPermissionHandler {
  Future<bool> hasPermissions() async {
    if (Platform.isAndroid) {
      return await Permission.bluetoothScan.status.isGranted &&
          await Permission.bluetoothConnect.status.isGranted &&
          await Permission.location.status.isGranted;
    }else return true;
  }

  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      await Permission.bluetooth.request();
      await Permission.bluetoothScan.request();
      await Permission.bluetoothConnect.request();
      await Permission.location.request();
    }
  }
}
