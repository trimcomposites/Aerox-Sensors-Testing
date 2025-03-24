import 'dart:async';

import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor_entity.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/connect_to_racket_sensor_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/disconnect_from_racket_sensor_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/start_scan_bluetooth_sensors_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/stop_scan_bluetooth_sensors_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

part 'sensors_event.dart';
part 'sensors_state.dart';
class SensorsBloc extends Bloc<SensorsEvent, SensorsState> {
  final StartScanBluetoothSensorsUsecase startScanBluetoothSensorsUsecase;
  final StoptScanBluetoothSensorsUsecase stopScanBluetoothSensorsUsecase;
  final ConnectToRacketSensorUsecase connectToRacketSensorUsecase;
  final DisconnectFromRacketSensorUsecase disconnectFromRacketSensorUsecase;
  StreamSubscription<List<RacketSensorEntity>>? _sensorSubscription;

  SensorsBloc({
    required this.startScanBluetoothSensorsUsecase,
    required this.stopScanBluetoothSensorsUsecase,
    required this.connectToRacketSensorUsecase,
    required this.disconnectFromRacketSensorUsecase
  }) : super(SensorsState(uiState: UIState.idle())) {
    
  void _listenToSensorStream(Stream<List<RacketSensorEntity>> stream) async {
      await _sensorSubscription?.cancel();

      _sensorSubscription = stream.listen((devices) {
        add(OnUpdateSensorsList(devices));
      });
    }
    /// **Iniciar escaneo**
    on<OnStartScanBluetoothSensors>((event, emit) async {
      emit(state.copyWith(uiState: UIState.loading(), sensors: [], selectedRacketEntity: state.selectedRacketEntity ));

      final result = await startScanBluetoothSensorsUsecase.call();
      result.fold(
        (failure) {
          emit(state.copyWith(uiState: UIState.error(failure.errMsg), selectedRacketEntity: state.selectedRacketEntity ));
        },
        (stream) {
          _listenToSensorStream(stream);
        },
      );
    });

    /// **Detener escaneo**
    on<OnStopScanBluetoothSensors>((event, emit) async {
      emit(state.copyWith(uiState: UIState.loading(), selectedRacketEntity: state.selectedRacketEntity ));

      final result = await stopScanBluetoothSensorsUsecase.call();
      result.fold(
        (failure) {
          emit(state.copyWith(uiState: UIState.error(failure.errMsg), selectedRacketEntity: state.selectedRacketEntity ));
        },
        (r) {
          emit(state.copyWith(sensors: [], selectedRacketEntity: state.selectedRacketEntity ));
        },
      );
    });

    on<OnUpdateSensorsList>((event, emit) {
      emit(state.copyWith(sensors: event.sensors, uiState: UIState.idle(), selectedRacketEntity: state.selectedRacketEntity ));
    });

    on<OnDisconnectSelectedRacket>((event, emit) async{
      final selectedRacket = state.selectedRacketEntity;
      if( selectedRacket != null ){
        // ignore: avoid_single_cascade_in_expression_statements
        await disconnectFromRacketSensorUsecase.call( selectedRacket )..fold(
        (failure) {
          emit(state.copyWith(uiState: UIState.error(failure.errMsg), selectedRacketEntity: state.selectedRacketEntity ));
        },
        (r) {
          emit(state.copyWith(selectedRacketEntity: null ));
        },);
      }
    });

    on<OnConnectRacketSensorEntity>((event, emit) async {
      emit(state.copyWith(uiState: UIState.loading(), selectedRacketEntity: state.selectedRacketEntity ));
      _sensorSubscription?.cancel();
      final entityIndex = state.sensors.indexWhere((element) => element.id == event.id);

      if (entityIndex != -1) {
        final updatedEntity = state.sensors[entityIndex];

        final result = await connectToRacketSensorUsecase.call(updatedEntity);
        result.fold(
          (failure) {
            emit(state.copyWith(uiState: UIState.error(failure.errMsg), selectedRacketEntity: state.selectedRacketEntity ));
          },
          (r) {
            final updatedSensors = List<RacketSensorEntity>.from(state.sensors);
            updatedSensors[entityIndex] = updatedEntity;
            
            emit(state.copyWith(selectedRacketEntity: updatedEntity, uiState: UIState.success( next: '/bluetooth')));
          },
        );
      }
    });


  }
}