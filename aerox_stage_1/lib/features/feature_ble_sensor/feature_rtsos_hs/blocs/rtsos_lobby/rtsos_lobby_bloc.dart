import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor_entity.dart';
import 'package:aerox_stage_1/domain/use_cases/ble_sensor/get_num_blobs_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/ble_sensor/start_offline_rtsos_usecase.dart';
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
  final GetNumBlobsUsecase getNumBlobsUsecase;
  RtsosLobbyBloc({
    required this.startOfflineRTSOSUseCase,
    required this.getSelectedBluetoothRacketUsecase,
    required this.disconnectFromRacketSensorUsecase,
    required this.getNumBlobsUsecase
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
on<OnGetSensorsNumBlobs>((event, emit) async {
  final currentEntity = state.sensorEntity;
  if (currentEntity == null) return;

  emit(state.copyWith( uiState: UIState.loading()));

  try {
    await Future.wait(
      currentEntity.sensors.map((sensor) async {

        final result = await getNumBlobsUsecase.call(sensor);

        await result.fold(
          (failure) async {

            emit(state.copyWith(
              uiState: UIState.error(''),
            ));
          },
          (numBlobs) async {
            final updatedSensors = state.sensorEntity!.sensors.map((s) {
              if (s.device.remoteId == sensor.device.remoteId) {
                return s.copyWith(
                  numBlobs: {numBlobs: BlobCheckStatus.mismatch},
                  numRetries: (s.numRetries >= 3) ? 1 : s.numRetries + 1
                );
              }
              return s;
            }).toList();

            emit(state.copyWith(
              sensorEntity: state.sensorEntity!.copyWith(sensors: updatedSensors),
            ));
          },
        );
      }),
    );

    final maxBlob = state.sensorEntity!.sensors
        .map((s) => s.numBlobs?.keys.first ?? 0)
        .fold<int>(0, (prev, value) => value > prev ? value : prev);

    final updatedFinalSensors = state.sensorEntity!.sensors.map((s) {
      final blob = s.numBlobs?.keys.first ?? 0;
      final retries = s.numRetries;

      final status = (retries >= 3 && blob != maxBlob)
          ? BlobCheckStatus.failed
          : (blob == maxBlob ? BlobCheckStatus.ok : BlobCheckStatus.mismatch);

      return s.copyWith(
        numBlobs: {blob: status},
      );
    }).toList();

    emit(state.copyWith(
      uiState: UIState.idle(),
      sensorEntity: state.sensorEntity!.copyWith(sensors: updatedFinalSensors),
    ));
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
