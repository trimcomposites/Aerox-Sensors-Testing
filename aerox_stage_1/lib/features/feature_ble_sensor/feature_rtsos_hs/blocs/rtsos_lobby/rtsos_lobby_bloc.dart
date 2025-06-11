import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/domain/models/error_log.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor_entity.dart';
import 'package:aerox_stage_1/domain/use_cases/ble_sensor/get_num_blobs_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/ble_sensor/get_sensor_battery_level_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/ble_sensor/start_offline_rtsos_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/blob_database/add_error_log_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/disconnect_from_racket_sensor_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/get_selected_bluetooth_racket_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:meta/meta.dart';

part 'rtsos_lobby_event.dart';
part 'rtsos_lobby_state.dart';

class RtsosLobbyBloc extends Bloc<RtsosLobbyEvent, RtsosLobbyState> {
  final StartOfflineRTSOSUseCase startOfflineRTSOSUseCase;
  final GetSelectedBluetoothRacketUsecase getSelectedBluetoothRacketUsecase;
  final DisconnectFromRacketSensorUsecase disconnectFromRacketSensorUsecase;
  final GetSensorBatteryLevelUsecase getSensorBatteryLevelUsecase;
  final GetNumBlobsUsecase getNumBlobsUsecase;
  final AddErrorLogUsecase addErrorLogUsecase;
  RtsosLobbyBloc({
    required this.startOfflineRTSOSUseCase,
    required this.getSelectedBluetoothRacketUsecase,
    required this.disconnectFromRacketSensorUsecase,
    required this.getNumBlobsUsecase,
    required this.addErrorLogUsecase,
    required this.getSensorBatteryLevelUsecase
  }) : super(RtsosLobbyState( selectedHitType: null, uiState: UIState.idle() )) {
    on<OnHitTypeValueChanged>((event, emit) {
      emit(state.copyWith(
          selectedHitType: event.newValue,
          
        ));
    });
    on<OnRtsosDurationChanged>((event, emit) {
      emit(state.copyWith(
          durationSeconds: event.newValue,
          
        ));
    });
    on<OnStopHSRecording>((event, emit) {
      emit(state.copyWith(
          isRecording: false
          
        ));
    });
    on<OnStartHSRecording>((event, emit) {
      emit(state.copyWith(
          isRecording: true
          
        ));
    });
    on<OnGetSelectedRacketSensorEntityLobby>((event, emit)async {
      // ignore: avoid_single_cascade_in_expression_statements
      await getSelectedBluetoothRacketUsecase.call()..fold(
        (l) => emit(state.copyWith( uiState: UIState.error( 'Error fetching Raqueta seleccionada' ) )), 
        (r) {
          emit(state.copyWith( sensorEntity: r ));
          add(OnGetSensorsNumBlobs());
        monitorSelectedRacketConnection();
        }
      );
    });
    on<OnStartHSBlobOnLobby>((event, emit) async {
      emit( state.copyWith( isRecording: true ) );
      final sensorEntity = state.sensorEntity;
      if (sensorEntity != null) {
        final futures = sensorEntity.sensors.map((sensor) {
          return startOfflineRTSOSUseCase.call(
            StartRTSOSParams(
              sampleRate: event.sampleRate,
              durationSeconds: event.duration,
              sensor: sensor,
            ),
          );
        }).toList();

        final results = await Future.wait(futures);

        final hasError = results.any((either) => either.isLeft());
        if (hasError) {
          emit(state.copyWith(
            uiState: UIState.error('Error al iniciar RTSOS en uno o más sensores'),
          ));
        } else {
          emit(state.copyWith(
            uiState: UIState.idle(),
          ));
        }
      }
    });
    on<OnChangeSampleRate>((event, emit) {
      emit(state.copyWith(
          sampleRate: event.sampleRate,
          
        ));
    });
      on<OnAutoDisconnectSelectedRacketLobby>((event, emit) async {
      final selectedRacket = state.sensorEntity;
      if (selectedRacket != null) {
        await disconnectFromRacketSensorUsecase.call(selectedRacket);
      }

      emit(state.copyWith(
        sensorEntity: null,
        uiState: UIState.error(event.errorMsg),
      ));
    });

      on<OnLogFailedRecord>((event, emit) async {
        final errorLog = ErrorLog(id: '', date: DateTime.now(), content: event.sensor.position.toString());
        await addErrorLogUsecase.call(errorLog);
        
    });
      on<OnAddBlobRecordedCounter>((event, emit) async {

      emit(state.copyWith(
        recordedBlobCounter: state.recordedBlobCounter+1
      ));
    });
      on<OnResetBlobRecordedCounter>((event, emit) async {

      emit(state.copyWith(
        recordedBlobCounter: 0
      ));
    });
        on<OnGetSensorBatteryLevelLobby>((event, emit) async {
          emit(state.copyWith( uiState: UIState.loading() ));
      final result = await getSensorBatteryLevelUsecase.call(event.sensor);
    
      result.fold(
        (err) => emit(state.copyWith(uiState: UIState.error(err.errMsg))),
        (batt) {
          final updatedSensor = event.sensor.copyWith(batteryLevel: batt.battPercent.round());

          final updatedEntity = state.sensorEntity?.copyWith(
            sensors: state.sensorEntity!.sensors.map((s) {
              return s.id == updatedSensor.id ? updatedSensor : s;
            }).toList(),
          );

          emit(state.copyWith(
            sensorEntity: updatedEntity,
            uiState: UIState.idle(),
          ));

          print('🔋 Batería actualizada: ${batt.battPercent.toStringAsFixed(1)}% para ${event.sensor.name}');
        },
      );
    });

on<OnGetSensorsNumBlobs>((event, emit) async {
  final currentEntity = state.sensorEntity;
  if (currentEntity == null) return;

  emit(state.copyWith(uiState: UIState.loading()));
  final previousSensors = currentEntity.sensors;

  try {
    await Future.wait(currentEntity.sensors.map((sensor) async {
      final result = await getNumBlobsUsecase.call(sensor);

      await result.fold(
        (failure) async {
          emit(state.copyWith(uiState: UIState.error('')));
        },
        (numBlobs) async {
          final updatedSensors = state.sensorEntity!.sensors.map((s) {
            if (s.device.remoteId == sensor.device.remoteId) {
              final oldStatus = s.numBlobs?.values.firstOrNull;
              final newStatus = (oldStatus == BlobCheckStatus.failed)
                  ? BlobCheckStatus.failed
                  : BlobCheckStatus.mismatch;

              return s.copyWith(
                numBlobs: {numBlobs: newStatus},
                numRetries: (oldStatus == BlobCheckStatus.failed)
                    ? s.numRetries
                    : (s.numRetries >= 2 ? 1 : s.numRetries + 1),
              );
            }
            return s;
          }).toList();

          emit(state.copyWith(
            sensorEntity: state.sensorEntity!.copyWith(sensors: updatedSensors),
          ));
        },
      );
    }));

    final maxBlob = state.sensorEntity!.sensors
        .map((s) => s.numBlobs?.keys.first ?? 0)
        .fold<int>(0, (prev, value) => value > prev ? value : prev);

    final updatedFinalSensors = state.sensorEntity!.sensors.map((s) {
      final blob = s.numBlobs?.keys.first ?? 0;
      final retries = s.numRetries;
      final currentStatus = s.numBlobs?.values.firstOrNull;

      final newStatus = (currentStatus == BlobCheckStatus.failed)
          ? BlobCheckStatus.failed
          : (retries >= 2 && blob != maxBlob)
              ? BlobCheckStatus.failed
              : (blob == maxBlob ? BlobCheckStatus.ok : BlobCheckStatus.mismatch);

      return s.copyWith(numBlobs: {blob: newStatus});
    }).toList();

    emit(state.copyWith(
      uiState: UIState.idle(),
      sensorEntity: state.sensorEntity!.copyWith(sensors: updatedFinalSensors),
    ));

    for (int i = 0; i < updatedFinalSensors.length; i++) {
      final newStatus = updatedFinalSensors[i].numBlobs?.values.firstOrNull;
      final oldStatus = previousSensors[i].numBlobs?.values.firstOrNull;

      if (oldStatus != BlobCheckStatus.failed && newStatus == BlobCheckStatus.failed) {
        add(OnLogFailedRecord(sensor: updatedFinalSensors[i]));
      }
    }
  } catch (e) {
    emit(state.copyWith(
      uiState: UIState.error('Error inesperado: $e'),
    ));
  }
});

 
  }
    bool verifyBlobs(RacketSensor sensor, int numBlobs) {
    final expected = sensor.numBlobs?.keys.firstOrNull;
    if (expected == null) return true;
    return expected == numBlobs;
  }

    void monitorSelectedRacketConnection() {
    state.sensorEntity?.sensors.forEach((sensor) {
      sensor.device.connectionState.listen((connectionState) {
        if (connectionState == BluetoothConnectionState.disconnected) {
          add(OnAutoDisconnectSelectedRacketLobby(
            errorMsg: 'Se ha perdido la conexión con los sensores. Reintenta la conexión.',
          ));
        }
      });
    });
  }
}
