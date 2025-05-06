import 'dart:isolate';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/ble_repository.dart';

class ReadBlobTaskHandler extends TaskHandler {
  final BleRepository bleRepository;

  ReadBlobTaskHandler({required this.bleRepository});
@pragma('vm:entry-point')
void startCallback() {
  if (bleRepository != null) {
    FlutterForegroundTask.setTaskHandler(
      ReadBlobTaskHandler(bleRepository: bleRepository!),
    );
  } else {
    print('❌ No hay instancia global de BleRepository');
  }
}

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    print('🔄 Iniciando tarea de lectura de blobs en segundo plano...');
    final result = await bleRepository.readBlobsFromConnectedSensorsForeground();
    result.fold(
      (err) => print('❌ Error: ${err.errMsg}'),
      (map) => print('✅ Blobs leídos de ${map.length} sensores.'),
    );
  }

  @override
  void onRepeatEvent(DateTime timestamp) {}

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    print('🧹 Servicio finalizado');
  }

  @override
  void onNotificationButtonPressed(String id) {}

  @override
  void onNotificationPressed() {
    FlutterForegroundTask.launchApp();
  }

  @override
  void onReceiveData(Object? data) {}
}
