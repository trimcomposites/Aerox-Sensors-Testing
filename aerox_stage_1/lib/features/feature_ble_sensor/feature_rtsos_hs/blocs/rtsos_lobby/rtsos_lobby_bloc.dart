import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'rtsos_lobby_event.dart';
part 'rtsos_lobby_state.dart';

class RtsosLobbyBloc extends Bloc<RtsosLobbyEvent, RtsosLobbyState> {
  RtsosLobbyBloc() : super(RtsosLobbyState( selectedHitType: null )) {
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
  }
}
