import 'dart:async';

import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor_entity.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/connect_to_racket_sensor_usecase.dart';
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
  final ConnectToRacketSensorUsecase connectToRacketSensorUsecase;
  StreamSubscription<List<RacketSensorEntity>>? _sensorSubscription;

  SensorsBloc({
    required this.startScanBluetoothSensorsUsecase,
    required this.stopScanBluetoothSensorsUsecase,
    required this.connectToRacketSensorUsecase,
  }) : super(SensorsState(uiState: UIState.idle())) {
    
  void _listenToSensorStream(Stream<List<RacketSensorEntity>> stream) async {
    await _sensorSubscription?.cancel();

    _sensorSubscription = stream.listen((devices) {
      add(OnUpdateSensorsList(devices));
    });
  }
    /// **Iniciar escaneo**
    on<OnStartScanBluetoothSensors>((event, emit) async {
      emit(state.copyWith(uiState: UIState.loading()));

      final result = await startScanBluetoothSensorsUsecase.call();
      result.fold(
        (failure) {
          emit(state.copyWith(uiState: UIState.error(failure.errMsg)));
        },
        (stream) {
          _listenToSensorStream(stream);
          emit(state.copyWith(uiState: UIState.success()));
        },
      );
    });

    /// **Detener escaneo**
    on<OnStopScanBluetoothSensors>((event, emit) async {
      emit(state.copyWith(uiState: UIState.loading()));

      final result = await stopScanBluetoothSensorsUsecase.call();
      result.fold(
        (failure) {
          emit(state.copyWith(uiState: UIState.error(failure.errMsg)));
        },
        (r) {
          emit(state.copyWith(sensors: [], uiState: UIState.success()));
        },
      );
    });

    on<OnUpdateSensorsList>((event, emit) {
      emit(state.copyWith(sensors: event.sensors, uiState: UIState.success()));
    });

    on<OnConnectRacketSensorEntity>((event, emit) async {
      emit(state.copyWith(uiState: UIState.loading()));

      final entityIndex = state.sensors.indexWhere((element) => element.id == event.id);

      if (entityIndex != -1) {
        final updatedEntity = state.sensors[entityIndex];

        final result = await connectToRacketSensorUsecase.call(updatedEntity);
        result.fold(
          (failure) {
            emit(state.copyWith(uiState: UIState.error(failure.errMsg)));
          },
          (r) {
            final updatedSensors = List<RacketSensorEntity>.from(state.sensors);
            updatedSensors[entityIndex] = updatedEntity;

            emit(state.copyWith(sensors: updatedSensors, uiState: UIState.success()));
          },
        );
      }
    });





  @override
  Future<void> close() {
    _sensorSubscription?.cancel();
    return super.close();
  }
}
}