import 'package:permission_handler/permission_handler.dart';

class BluetoothPermissionHandler {
  Future<bool> hasPermissions() async {
    return await Permission.bluetoothScan.status.isGranted &&
        await Permission.bluetoothConnect.status.isGranted;
        //await Permission.location.status.isGranted;
  }

  Future<void> requestPermissions() async {
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    //await Permission.location.request();
  }
}