import 'dart:async';

import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/start_scan_bluetooth_sensors_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/stop_scan_bluetooth_sensors_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sensors_event.dart';
part 'sensors_state.dart';
class SensorsBloc extends Bloc<SensorsEvent, SensorsState> {
  final StartScanBluetoothSensorsUsecase startScanBluetoothSensorsUsecase;
  final StoptScanBluetoothSensorsUsecase stopScanBluetoothSensorsUsecase;
  StreamSubscription<List<RacketSensor>>? _sensorSubscription;

  SensorsBloc({
    required this.startScanBluetoothSensorsUsecase,
    required this.stopScanBluetoothSensorsUsecase
  }) : super(SensorsState()) {
    on<OnStartScanBluetoothSensors>((event, emit) async {
      final result = await startScanBluetoothSensorsUsecase.call();
      result.fold(
        (failure) {
          //TODO: IMPLEMENTAR uistate en sensorsbloc
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
          //TODO: IMPLEMENTAR uistate en sensorsbloc
        },
        (r) {
          emit( state.copyWith( sensors: [] ) );
        },
      );
    });

    on<UpdateSensorsList>((event, emit) {
      emit(state.copyWith(sensors: event.sensors));
    });
  }

  void _listenToSensorStream(Stream<List<RacketSensor>> stream) async {

    await _sensorSubscription?.cancel();

    _sensorSubscription = stream.listen((devices) {
      add(UpdateSensorsList(devices));
    });
  }

  @override
  Future<void> close() {
    _sensorSubscription?.cancel(); 
    return super.close();
  }
}


