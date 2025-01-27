import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'details_screen_event.dart';
part 'details_screen_state.dart';

class DetailsScreenBloc extends Bloc<DetailsScreenEvent, DetailsScreenState> {
  DetailsScreenBloc() 
  : super(IdleDetailsScreenState());

}
