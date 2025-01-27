import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'details_screen_event.dart';
part 'details_screen_state.dart';

class DetailsScreenBloc extends Bloc<DetailsScreenEvent, DetailsScreenState> {
  DetailsScreenBloc() : super(DetailsScreenInitial()) {
    on<DetailsScreenEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
