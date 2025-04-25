import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor_entity.dart';
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
  RtsosLobbyBloc({
    required this.startOfflineRTSOSUseCase,
    required this.getSelectedBluetoothRacketUsecase,
    required this.disconnectFromRacketSensorUsecase
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
    on<OnGetSelectedRacketSensorEntityLobby>((event, emit)async {
      // ignore: avoid_single_cascade_in_expression_statements
      await getSelectedBluetoothRacketUsecase.call()..fold(
        (l) => emit(state.copyWith( uiState: UIState.error( 'Error fetching Raqueta seleccionada' ) )), 
        (r) {
          emit(state.copyWith( sensorEntity: r ));
        monitorSelectedRacketConnection();
        }
      );
    });
    on<OnStartHSBlobOnLobby>((event, emit) {
      final sensorEntity = state.sensorEntity;
      if(sensorEntity!=null){
        for (var sensor in sensorEntity.sensors){
           startOfflineRTSOSUseCase.call( StartRTSOSParams(sampleRate: event.sampleRate, durationSeconds: event.duration, sensor: sensor) );
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
