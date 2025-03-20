import 'dart:async';

import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/scan_bluetooth_sensors_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sensors_event.dart';
part 'sensors_state.dart';
class SensorsBloc extends Bloc<SensorsEvent, SensorsState> {
  final ScanBluetoothSensorsUsecase scanBluetoothSensorsUsecase;
  StreamSubscription<List<RacketSensor>>? _sensorSubscription;

  SensorsBloc({required this.scanBluetoothSensorsUsecase}) : super(SensorsState()) {
    on<OnScanBluetoothSensors>((event, emit) async {
      final result = await scanBluetoothSensorsUsecase.call();
      result.fold(
        (failure) {
          //emit(state.copyWith(error: "Error al obtener sensores"));
        },
        (stream) {
          _listenToSensorStream(stream);
        },
      );
    });

    on<UpdateSensorsList>((event, emit) {
      emit(state.copyWith(sensors: event.sensors));
    });
  }

  /// Escucha el stream y actualiza la lista de sensores mediante un nuevo evento
  void _listenToSensorStream(Stream<List<RacketSensor>> stream) async {
    // Cancelar suscripción previa si existe
    await _sensorSubscription?.cancel();

    _sensorSubscription = stream.listen((devices) {
      add(UpdateSensorsList(devices)); // ✅ Usar add() en lugar de emitir directamente
    });
  }

  @override
  Future<void> close() {
    _sensorSubscription?.cancel(); // Cancelar la suscripción al cerrar el Bloc
    return super.close();
  }
}

/// Evento para actualizar la lista de sensores
class UpdateSensorsList extends SensorsEvent {
  final List<RacketSensor> sensors;
  UpdateSensorsList(this.sensors);
}
