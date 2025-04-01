import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as p;

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class BLEDataLogger {
  final BluetoothDevice device;
  final Guid serviceUuid;

  BLEDataLogger({
    required this.device,
    required this.serviceUuid,
  });

  Future<void> startLogging({Duration duration = const Duration(seconds: 15)}) async {
    final List<String> csvRows = [];

    // ✅ Permisos
    await _ensurePermissions();

    // 🔍 Buscar servicios y características
    final services = await device.discoverServices();
    final service = services.firstWhere((s) => s.uuid == serviceUuid);

    // 🧠 Buscar la primera característica que tenga notify = true
    final notifyCharacteristic = service.characteristics.firstWhere(
      (c) => c.properties.notify == true,
      orElse: () => throw Exception("❌ No se encontró ninguna característica con notify en el servicio $serviceUuid"),
    );

    // ✅ Activar notificaciones
    await notifyCharacteristic.setNotifyValue(true);
    print("📡 Notificación activada en ${notifyCharacteristic.uuid}");

    // 📥 Suscribirse a notificaciones
// 📥 Suscribirse a notificaciones
    final subscription = notifyCharacteristic.onValueReceived.listen((data) {
      final timestamp = DateTime.now().toIso8601String();

      // Imprimir los datos recibidos en bruto
      //print("📥 Datos recibidos: $data");

      // Convertir List<int> a Uint8List
      final parsed = _parseSensorPacket(Uint8List.fromList(data)); // Convierte a Uint8List

      // Imprimir los datos decodificados
      print("📊 Datos decodificados: ${parsed.join(', ')}");

      // Añadir los datos procesados al CSV
      csvRows.add('$timestamp,${parsed.join(', ')}');
    });

    // ⏱ Esperar para recolectar datos
    await Future.delayed(duration);

    // 🔕 Desactivar notificaciones
    await notifyCharacteristic.setNotifyValue(false);
    await subscription.cancel();

    print("✅ Recopilación finalizada, guardando CSV...");
    await _saveCsv(csvRows);
  }

  // 🧠 Función para parsear los datos binarios recibidos
  List<double> _parseSensorPacket(Uint8List data) {
    final buffer = ByteData.sublistView(data);

    // Decodificación de valores de acelerómetro (acc_x, acc_y, acc_z) y giroscopio (gyro_x, gyro_y, gyro_z)
    final accX = buffer.getInt16(0, Endian.little) / 1000.0;
    final accY = buffer.getInt16(2, Endian.little) / 1000.0;
    final accZ = buffer.getInt16(4, Endian.little) / 1000.0;

    final gyroX = buffer.getInt16(6, Endian.little) / 10.0;
    final gyroY = buffer.getInt16(8, Endian.little) / 10.0;
    final gyroZ = buffer.getInt16(10, Endian.little) / 10.0;

    final deltaT = buffer.getInt16(12, Endian.little).toDouble();
    final absoluteTime = buffer.getInt16(14, Endian.little).toDouble();

    // Asumimos que estos valores se encuentran en un orden similar en la memoria del paquete
    return [gyroX, gyroY, gyroZ, accX, accY, accZ, deltaT, absoluteTime];
  }

  Future<void> _saveCsv(List<String> rows) async {
    try {
      print("✅ Recopilación finalizada, guardando CSV...");

      // ✅ Carpeta interna de documentos de la app
      final appDir = await getApplicationDocumentsDirectory();
      final debugDir = Directory(p.join(appDir.path, 'debug_logs'));

      if (!await debugDir.exists()) {
        print("📁 Carpeta debug_logs no existe. Creando...");
        await debugDir.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = p.join(debugDir.path, 'ble_data_$timestamp.csv');

      final file = File(filePath);
      final csvContent = StringBuffer()..writeln('gyro_x,gyro_y,gyro_z,acc_x,acc_y,acc_z,delta_t,absolute_time,timestamp');

      // Añadir filas de datos al CSV
      for (final row in rows) {
        csvContent.writeln(row);
      }

      await file.writeAsString(csvContent.toString());

      print("📁 CSV guardado en: $filePath");
      print("CSV");
      print(rows);

    } catch (e) {
      print("❌ Error al guardar CSV: $e");
    }
  }

  Future<void> _ensurePermissions() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        throw Exception("🔒 Permiso de almacenamiento denegado.");
      }
    }
  }
}
