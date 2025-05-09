import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/domain/models/blob.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor_entity.dart';
import 'package:aerox_stage_1/domain/use_cases/ble_sensor/erase_storage_data_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/ble_sensor/get_sensor_timestamp_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/ble_sensor/parse_blob_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/ble_sensor/read_storage_data_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/ble_sensor/set_sensor_timestamp.dart';
import 'package:aerox_stage_1/domain/use_cases/ble_sensor/start_offline_rtsos_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/ble_sensor/stop_offline_rtsos_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/ble_sensor/stream_rtsos_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/disconnect_from_racket_sensor_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/get_selected_bluetooth_racket_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

part 'selected_entity_page_event.dart';
part 'selected_entity_page_state.dart';

class SelectedEntityPageBloc extends Bloc<SelectedEntityPageEvent, SelectedEntityPageState> {
  final DisconnectFromRacketSensorUsecase disconnectFromRacketSensorUsecase;
  final GetSelectedBluetoothRacketUsecase getSelectedBluetoothRacketUsecase;
  final StartOfflineRTSOSUseCase startOfflineRTSOSUseCase;
  final StoptOfflineRTSOSUseCase stopOfflineRTSOSUseCase;
  final ReadStorageDataUsecase readStorageDataUsecase;
  final StreamRTSOSUsecase startStreamRTSOS;
  final ParseBlobUsecase parseBlobUsecase;
  final EraseStorageDataUsecase eraseStorageDataUsecase;
  final SetSensorTimestampUseCase setTimestampUseCase;
  final GetSensorTimestampUseCase getTimestampUseCase;

  SelectedEntityPageBloc({
    required this.disconnectFromRacketSensorUsecase,
    required this.getSelectedBluetoothRacketUsecase,
    required this.startOfflineRTSOSUseCase,
    required this.stopOfflineRTSOSUseCase,
    required this.readStorageDataUsecase,
    required this.startStreamRTSOS,
    required this.parseBlobUsecase,
    required this.eraseStorageDataUsecase,
    required this.setTimestampUseCase,
    required this.getTimestampUseCase
  }) : super(SelectedEntityPageState(uiState: UIState.idle())) {

    on<OnDisconnectSelectedRacketSelectedEntityPage>((event, emit) async {
      emit(state.copyWith(uiState: UIState.loading()));
      final selectedRacket = state.selectedRacketEntity;
      if (selectedRacket != null) {
        await disconnectFromRacketSensorUsecase.call(selectedRacket).then((either) {
          either.fold(
            (failure) => emit(state.copyWith(uiState: UIState.error(failure.errMsg))),
            (_) => emit(state.copyWith(selectedRacketEntity: null, uiState: UIState.idle())),
          );
        });
      }
    });

    on<OnAutoDisconnectSelectedRacket>((event, emit) async {
      final selectedRacket = state.selectedRacketEntity;
      if (selectedRacket != null) {
        await disconnectFromRacketSensorUsecase.call(selectedRacket);
      }
      emit(state.copyWith(
        selectedRacketEntity: null,
        uiState: UIState.error(event.errorMsg),
      ));
    });

    on<OnGetSelectedRacketSelectedEntityPage>((event, emit) async {
      await getSelectedBluetoothRacketUsecase.call().then((either) {
        either.fold(
          (failure) => emit(state.copyWith(uiState: UIState.error(failure.errMsg), selectedRacketEntity: null)),
          (r) {
            emit(state.copyWith(selectedRacketEntity: r, uiState: UIState.idle()));
            monitorSelectedRacketConnection();
          },
        );
      });
    });

    on<OnShowConnectionError>((event, emit) {
      emit(state.copyWith(uiState: UIState.error(event.errorMsg)));
    });

    on<OnStartHSBlob>((event, emit) async {
      emit(state.copyWith(uiState: UIState.loading()));
      await startOfflineRTSOSUseCase.call(StartRTSOSParams(sampleRate: SampleRate.khz1, durationSeconds: 5, sensor: event.sensor)).then(
        (either) => either.fold(
          (l) => emit(state.copyWith(uiState: UIState.error(l.errMsg))),
          (r) => emit(state.copyWith(uiState: UIState.idle())),
        ),
      );
    });

    on<OnStopHSBlob>((event, emit) async {
      emit(state.copyWith(uiState: UIState.loading()));
      await stopOfflineRTSOSUseCase.call(event.sensor).then(
        (either) => either.fold(
          (l) => emit(state.copyWith(uiState: UIState.error(l.errMsg))),
          (r) => emit(state.copyWith(uiState: UIState.idle())),
        ),
      );
    });

    on<OnReadStorageData>((event, emit) async {
      emit(state.copyWith(uiState: UIState.loading()));
      await readStorageDataUsecase.call(event.sensor).then((either) {
        either.fold(
          (l) => emit(state.copyWith(uiState: UIState.error(l.errMsg))),
          (r) => emit(state.copyWith(blobs: r, uiState: UIState.idle())),
        );
      });
    });

    on<OnSetTimeStamp>((event, emit) async {
      await setTimestampUseCase.call(event.sensor).then((either) {
        either.fold(
          (l) => emit(state.copyWith(uiState: UIState.error(l.errMsg))),
          (r) => emit(state.copyWith(uiState: UIState.idle())),
        );
      });
    });

    on<OnGetTimeStamp>((event, emit) async {
      emit(state.copyWith(uiState: UIState.loading()));
      await getTimestampUseCase.call(event.sensor).then((either) {
        either.fold(
          (l) => emit(state.copyWith(uiState: UIState.error(l.errMsg))),
          (r) => emit(state.copyWith(uiState: UIState.idle())),
        );
      });
    });

    on<OnParseBlob>((event, emit) async {
      emit(state.copyWith(uiState: UIState.loading()));
      await parseBlobUsecase.call(event.blob).then((either) {
        either.fold(
          (l) => emit(state.copyWith(uiState: UIState.error(l.errMsg))),
          (_) => emit(state.copyWith(uiState: UIState.idle())),
        );
      });
    });

    on<OnStartStreamRTSOS>((event, emit) async {
      emit(state.copyWith(uiState: UIState.loading()));
      await startStreamRTSOS.call(event.sensor).then((either) {
        either.fold(
          (l) => emit(state.copyWith(uiState: UIState.error(l.errMsg))),
          (r) => emit(state.copyWith(uiState: UIState.idle())),
        );
      });
    });

    on<OnEraseStorageData>((event, emit) async {
      final racket = state.selectedRacketEntity;

      if (racket == null) {
        emit(state.copyWith(uiState: UIState.error('No hay raqueta seleccionada')));
        return;
      }

      emit(state.copyWith(uiState: UIState.loading()));

      final futures = racket.sensors.map((sensor) {
        return eraseStorageDataUsecase.call(sensor);
      }).toList();

      final results = await Future.wait(futures);

      final hasError = results.any((either) => either.isLeft());

      if (hasError) {
        final failed = results
            .asMap()
            .entries
            .where((entry) => entry.value.isLeft())
            .map((entry) => racket.sensors[entry.key].device.remoteId.str)
            .toList();

        emit(state.copyWith(
          uiState: UIState.error('Error al borrar sensores: ${failed.join(", ")}'),
        ));
      } else {
        emit(state.copyWith(uiState: UIState.idle()));

      }
    });
  }
  void disconnectAllSensors(){
      state.selectedRacketEntity?.sensors.forEach((sensor) {
      sensor.device.connectionState.listen((connectionState) {
          add(OnAutoDisconnectSelectedRacket(
            errorMsg: 'Tras borrar el almacenamiento, es necesario volver a conectar los sensores.',
          ));
      });
    });
  }
      
  void monitorSelectedRacketConnection() {
    state.selectedRacketEntity?.sensors.forEach((sensor) {
      sensor.device.connectionState.listen((connectionState) {
        if (connectionState == BluetoothConnectionState.disconnected) {
          add(OnAutoDisconnectSelectedRacket(
            errorMsg: 'Se ha perdido la conexión con los sensores. Reintenta la conexión.',
          ));
        }
      });
    });
  }
}