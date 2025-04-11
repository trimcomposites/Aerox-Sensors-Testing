import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor_entity.dart';
import 'package:aerox_stage_1/domain/use_cases/ble_sensor/start_offline_rtsos_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/get_selected_bluetooth_racket_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'rtsos_lobby_event.dart';
part 'rtsos_lobby_state.dart';

class RtsosLobbyBloc extends Bloc<RtsosLobbyEvent, RtsosLobbyState> {
  final StartOfflineRTSOSUseCase startOfflineRTSOSUseCase;
  final GetSelectedBluetoothRacketUsecase getSelectedBluetoothRacketUsecase;
  RtsosLobbyBloc({
    required this.startOfflineRTSOSUseCase,
    required this.getSelectedBluetoothRacketUsecase
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
      await getSelectedBluetoothRacketUsecase.call()..fold(
        (l) => emit(state.copyWith( uiState: UIState.error( 'Error fetching Raqueta seleccionada' ) )), 
        (r) => emit(state.copyWith( sensorEntity: r ))
      );
    });
    on<OnStartHSBlobOnLobby>((event, emit) {
      final sensorEntity = state.sensorEntity;
      if(sensorEntity!=null){
        for (var sensor in sensorEntity.sensors){
          startOfflineRTSOSUseCase.call(sensor);
        }
      }
    });
  }
}
