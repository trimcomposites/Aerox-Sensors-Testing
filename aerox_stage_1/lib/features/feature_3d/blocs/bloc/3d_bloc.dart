import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part '3d_event.dart';
part '3d_state.dart';

class Model3DBloc extends Bloc<Model3DEvent, Model3DState> {
  Model3DBloc() : super( Model3DState(uiState: UIState.idle()) ) {
    on<OnStartLoadingModel3d>((event, emit) {
      emit( state.copyWith( uiState: UIState.loading() ) );
    });
    on<OnStopLoadingModel3d>((event, emit) {
      emit( state.copyWith( uiState: UIState.success() ) );
    });
    on<OnStartErrorModel3d>((event, emit) {
      emit( state.copyWith( uiState: UIState.error( '' ) ) );
    });
  }
}
