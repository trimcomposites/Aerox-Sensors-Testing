import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:intl/intl.dart';

class BleReadOfflineRTSOSBLOB {
  static const String OFFLINE_SERVICE_SERVICE_UUID = '71d713ef-799e-42af-9d57-9803e36b0f93';
  static const String OFFLINE_SERVICE_CONTROL_POINT_CHARACTERISTIC_UUID = 'a84ce035-60ed-4b24-99c9-8683052aa48b';
  static const int RTSOS_BLOB_REGISTER_TYPE = 0x05;

  final BluetoothDevice device;

  BleReadOfflineRTSOSBLOB({required this.device});

  Future<void> startRTSOSBlobRegister({
    int sampleRate = 50,
    bool includeAcc = true,
    bool includeGyro = true,
    bool includeAngles = true,
    bool useImuRef = false,
    int inactivityTimeout = 10,
    int minSleepTime = 1,
  }) async {
    if (device.connectionState!=BluetoothConnectionState.connected) {
      print("Device not connected.");
      return;
    }

    final requiredData = _buildRequiredData(includeAcc, includeGyro, includeAngles, useImuRef);

    // Comando para comenzar el registro de RTSOS Blob
    final cmd = [
      0x20, // Operation code for start RTSOS Blob Register
      sampleRate,
      requiredData,
      inactivityTimeout,
      minSleepTime,
    ];

    await _executeCommand(cmd);
  }

  Future<void> _executeCommand(List<int> cmd) async {
    // Envía el comando a través de BLE para registrar el blob
    final characteristic = await _getControlPointCharacteristic();
    await characteristic.write([0x20]);
    print("Command sent: $cmd");

    // Leer la respuesta
    final response = await characteristic.read();
    print("Response: $response");

    if (response.isNotEmpty && response[1] == 0) {
      print("RTSOS Blob Register started successfully");
    } else {
      print("Error starting RTSOS Blob Register");
    }
  }

  Future<BluetoothCharacteristic> _getControlPointCharacteristic() async {
    // Descubre los servicios y características del dispositivo
    final services = await device.discoverServices();
    final service = services.firstWhere(
        (s) => s.uuid.toString() == OFFLINE_SERVICE_SERVICE_UUID);
    final characteristic = service.characteristics.firstWhere(
        (c) => c.uuid.toString() == OFFLINE_SERVICE_CONTROL_POINT_CHARACTERISTIC_UUID);
    return characteristic;
  }

  int _buildRequiredData(bool includeAcc, bool includeGyro, bool includeAngles, bool useImuRef) {
    int requiredData = 0;
    requiredData |= includeAcc ? 0x04 : 0; // Accel data mask
    requiredData |= includeGyro ? 0x02 : 0; // Gyro data mask
    requiredData |= includeAngles ? 0x08 : 0; // Angle data mask
    requiredData |= useImuRef ? 0x40 : 0; // IMU reference mask
    return requiredData;
  }

  // Función para leer los datos del sensor (simulando la recepción)
  Future<void> readSensorData() async {
    // Aquí podrías configurar la suscripción a las notificaciones de datos
    final characteristic = await _getControlPointCharacteristic();
    characteristic.setNotifyValue(true);

    characteristic.value.listen((data) {
      final timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      final parsedData = _parseSensorData(data);
      print("[$timestamp] Sensor Data: $parsedData");
    });
  }

  List<double> _parseSensorData(List<int> data) {
    // Parsear los datos del sensor, dependiendo del formato de los datos recibidos.
    // Esto es un ejemplo genérico de cómo podrías parsear los datos.
    List<double> parsedData = [];
    for (int i = 0; i < data.length; i += 2) {
      final value = (data[i] | (data[i + 1] << 8)).toDouble();
      parsedData.add(value);
    }
    return parsedData;
  }

  Future<void> stopRTSOSBlobRegister() async {
    if (device.connectionState!=BluetoothConnectionState.connected) {
      print("Device not connected.");
      return;
    }

    final cmd = [0x2F]; // Operation code for stopping RTSOS Blob Register
    await _executeCommand(cmd);
  }

  // Consultar el estado del Blob Register
  Future<void> getBlobRegisterStatus() async {
    if (device.connectionState!=BluetoothConnectionState.connected) {
      print("Device not connected.");
      return;
    }

    final cmd = [0x2E]; // Operation code for getting RTSOS Blob Register status
    await _executeCommand(cmd);
  }
}
