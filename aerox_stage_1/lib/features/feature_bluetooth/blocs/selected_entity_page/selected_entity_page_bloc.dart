import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor_entity.dart';
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

  SelectedEntityPageBloc({ 
    required this.disconnectFromRacketSensorUsecase,
    required this.getSelectedBluetoothRacketUsecase
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
  }

  void monitorSelectedRacketConnection() {
    //TODO Comprobar si funciona enuna desconexion real
    
    state.selectedRacketEntity?.sensors.forEach((sensor) {
      sensor.device.connectionState.listen((connectionState) {
        if (connectionState == BluetoothConnectionState.disconnected) {
          add(OnDisconnectSelectedRacketSelectedEntityPage());
        }
      });
    });
  }
}
