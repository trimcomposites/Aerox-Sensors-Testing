import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor_entity.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/disconnect_from_racket_sensor_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/get_selected_bluetooth_racket_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
part 'selected_entity_page_event.dart';
part 'selected_entity_page_state.dart';


class SelectedEntityPageBloc extends Bloc<SelectedEntityPageEvent, SelectedEntityPageState> {
  final DisconnectFromRacketSensorUsecase disconnectFromRacketSensorUsecase;
  final GetSelectedBluetoothRacketUsecase getSelectedBluetoothRacketUsecase;

  SelectedEntityPageBloc({ 
    required this.disconnectFromRacketSensorUsecase,
    required this.getSelectedBluetoothRacketUsecase
    }) : super(SelectedEntityPageState( uiState: UIState.idle() )) {
    on<OnDisconnectSelectedRacketSelectedEntityPage>((event, emit) async{
      emit(state.copyWith(uiState: UIState.loading(), selectedRacketEntity: state.selectedRacketEntity));
      final selectedRacket = state.selectedRacketEntity;
      if( selectedRacket != null ){
        // ignore: avoid_single_cascade_in_expression_statements
        await disconnectFromRacketSensorUsecase.call( selectedRacket )..fold(
        (failure) {
          emit(state.copyWith(uiState: UIState.error(failure.errMsg)));
        },
        (r) {
          emit(state.copyWith(selectedRacketEntity: null,  uiState: UIState.idle()));
        },);
      }
    });
    on<OnGetSelectedRacketSelectedEntityPage>((event, emit) async{
        emit(state.copyWith(uiState: UIState.loading(), selectedRacketEntity: state.selectedRacketEntity));
        // ignore: avoid_single_cascade_in_expression_statements
        await getSelectedBluetoothRacketUsecase.call()..fold(
        (failure) {
          emit(state.copyWith(uiState: UIState.error(failure.errMsg), selectedRacketEntity: null));
        },
        (r) {
          emit(state.copyWith(selectedRacketEntity: r, uiState: UIState.idle()));
        },);
      }
    );
  }
}
