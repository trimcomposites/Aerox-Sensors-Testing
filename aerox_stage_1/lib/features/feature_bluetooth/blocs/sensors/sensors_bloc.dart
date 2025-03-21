import 'dart:async';

import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor_entity.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/start_scan_bluetooth_sensors_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/stop_scan_bluetooth_sensors_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

part 'sensors_event.dart';
part 'sensors_state.dart';

class SensorsBloc extends Bloc<SensorsEvent, SensorsState> {
  final StartScanBluetoothSensorsUsecase startScanBluetoothSensorsUsecase;
  final StoptScanBluetoothSensorsUsecase stopScanBluetoothSensorsUsecase;
  StreamSubscription<List<RacketSensorEntity>>? _sensorSubscription;

  SensorsBloc({
    required this.startScanBluetoothSensorsUsecase,
    required this.stopScanBluetoothSensorsUsecase,
  }) : super(SensorsState()) {
    on<OnStartScanBluetoothSensors>((event, emit) async {
      final result = await startScanBluetoothSensorsUsecase.call();
      result.fold(
        (failure) {
          // TODO: Implementar UIState para manejar errores
        },
        (stream) {
          _listenToSensorStream(stream);
        },
      );
    });

    on<OnStopScanBluetoothSensors>((event, emit) async {
      final result = await stopScanBluetoothSensorsUsecase.call();
      result.fold(
        (failure) {
          // TODO: Implementar UIState para manejar errores
        },
        (r) {
          emit(state.copyWith(sensors: []));
        },
      );
    });

    on<UpdateSensorsList>((event, emit) {
      emit(state.copyWith(sensors: event.sensors));
    });

    on<RemoveDisconnectedSensor>((event, emit) {
      final updatedSensors = state.sensors.where((s) => s.id != event.id).toList();
      emit(state.copyWith(sensors: updatedSensors));
    });
  }

  void _listenToSensorStream(Stream<List<RacketSensorEntity>> stream) async {
    await _sensorSubscription?.cancel();

    _sensorSubscription = stream.listen((devices) {
      add(UpdateSensorsList(devices));

      // // Monitorear la conexión de cada dispositivo
      // for (var sensor in devices) {
      //   sensor.device.connectionState.listen((state) {
      //     if (state == BluetoothConnectionState.disconnected) {
      //       print("❌ Dispositivo desconectado: ${sensor.device.platformName}");
      //       add(RemoveDisconnectedSensor(id: sensor.id));
      //     }
      //   });
    
      
    });
  }

  @override
  Future<void> close() {
    _sensorSubscription?.cancel();
    return super.close();
  }
}
