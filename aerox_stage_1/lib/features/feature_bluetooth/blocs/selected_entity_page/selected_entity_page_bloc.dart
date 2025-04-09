import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/domain/models/blob.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor_entity.dart';
import 'package:aerox_stage_1/domain/use_cases/ble_sensor/erase_storage_data_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/ble_sensor/parse_blob_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/ble_sensor/read_storage_data_usecase.dart';
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
  final  StoptOfflineRTSOSUseCase stopOfflineRTSOSUseCase;
  final  ReadStorageDataUsecase readStorageDataUsecase;
  final StreamRTSOSUsecase startStreamRTSOS;
  final ParseBlobUsecase parseBlobUsecase;
  final EraseStorageDataUsecase eraseStorageDataUsecase;


  SelectedEntityPageBloc({ 
    required this.disconnectFromRacketSensorUsecase,
    required this.getSelectedBluetoothRacketUsecase,
    required this.startOfflineRTSOSUseCase,
    required this.stopOfflineRTSOSUseCase,
    required this.readStorageDataUsecase,
    required this.startStreamRTSOS,
    required this.parseBlobUsecase,
    required this.eraseStorageDataUsecase,
  }) : super(SelectedEntityPageState(uiState: UIState.idle())) {
    
    on<OnDisconnectSelectedRacketSelectedEntityPage>((event, emit) async {
      emit(state.copyWith(uiState: UIState.loading(), selectedRacketEntity: state.selectedRacketEntity));

      final selectedRacket = state.selectedRacketEntity;
      if (selectedRacket != null) {
        await disconnectFromRacketSensorUsecase.call(selectedRacket).then((either) {
          either.fold(
            (failure) {
              emit(state.copyWith(uiState: UIState.error(failure.errMsg)));
            },
            (r) {
              emit(state.copyWith(selectedRacketEntity: null, uiState: UIState.idle()));
            },
          );
        });
      }
    });

    on<OnGetSelectedRacketSelectedEntityPage>((event, emit) async {
      emit(state.copyWith(uiState: UIState.loading(), selectedRacketEntity: state.selectedRacketEntity));

      await getSelectedBluetoothRacketUsecase.call().then((either) {
        either.fold(
          (failure) {
            emit(state.copyWith(uiState: UIState.error(failure.errMsg), selectedRacketEntity: null));
          },
          (r) {
            emit(state.copyWith(selectedRacketEntity: r, uiState: UIState.idle()));
            monitorSelectedRacketConnection();
          },
        );
      });
    });
  
    on<OnShowConnectionError>((event, emit) async {

      emit(state.copyWith(uiState: UIState.error( event.errorMsg ) ));
    });
    on<OnStartHSBlob>((event, emit) async {

      await startOfflineRTSOSUseCase.call( event.sensor );
    });
    
  
    on<OnStopHSBlob>((event, emit) async {

      await stopOfflineRTSOSUseCase.call( event.sensor );
    });
    
  
    on<OnReadStorageData>((event, emit) async {

      // ignore: avoid_single_cascade_in_expression_statements
      await readStorageDataUsecase.call( event.sensor )..fold(
        (l) =>  emit(state.copyWith(uiState: UIState.error(l.errMsg))), 
        (r) => emit(state.copyWith(blobs: r)));
    });
    on<OnParseBlob>((event, emit) async {

      // ignore: avoid_single_cascade_in_expression_statements
      await parseBlobUsecase.call( event.blob )..fold(
        (l) =>  emit(state.copyWith(uiState: UIState.error(l.errMsg))), 
        (r) =>{});
        // (r) => emit(state.copyWith(blobs: r)));
    });
    on<OnStartStreamRTSOS>((event, emit) async {

      await startStreamRTSOS.call( event.sensor );
    });
    on<OnEraseStorageData>((event, emit) async {
  emit(state.copyWith(uiState: UIState.loading()));

  final result = await eraseStorageDataUsecase.call(event.sensor);
  result.fold(
    (err) => emit(state.copyWith(uiState: UIState.error(err.errMsg))),
    (_) => emit(state.copyWith(uiState: UIState.success())),
    );
  });

  }

  void monitorSelectedRacketConnection() {
    state.selectedRacketEntity?.sensors.forEach((sensor) {
      sensor.device.connectionState.listen((connectionState) {
        if (connectionState == BluetoothConnectionState.disconnected) {
          add(OnDisconnectSelectedRacketSelectedEntityPage());
          add( OnShowConnectionError(errorMsg: 'Ha habido un problema de Conexión, comprueba los sensores y vuelve a intentarlo.') );
        }
      });
    });
  }
}
