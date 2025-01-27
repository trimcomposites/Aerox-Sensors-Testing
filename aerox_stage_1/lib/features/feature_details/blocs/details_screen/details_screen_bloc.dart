import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'details_screen_event.dart';
part 'details_screen_state.dart';

class DetailsScreenBloc extends Bloc<DetailsScreenEvent, DetailsScreenState> {
  DetailsScreenBloc() 
  : super(DetailsScreenState(
    isLoading: false,
    isError: false
  )) {
    on<OnStartDetailsScreenLoading>((event, emit) {
      emit( state.copyWith( isLoading: true ) );
    });

    on<OnStopDetailsScreenLoading>((event, emit) {
      emit( state.copyWith( isLoading: false ) );
    });

    on<OnStartDetailsScreenError>((event, emit) {
      emit( state.copyWith( isError: true ) );
    });

    on<OnStopDetailsScreenError>((event, emit) {
      emit( state.copyWith( isError: false ) );
    });
  }
}
