import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/get_selected_racket.usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_screen_event.dart';
part 'home_screen_state.dart';


class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  final GetSelectedRacketUsecase getSelectedRacketUsecase;
  HomeScreenBloc({
    required this.getSelectedRacketUsecase,

  }) : super(HomeScreenState()) {
    on<OnGetSelectedRacket>((event, emit) async {
      // ignore: avoid_single_cascade_in_expression_statements
      await getSelectedRacketUsecase()..fold(
        (l) => ( emit(state.copyWith( racket: null )) ),
        (r) => ( emit( state.copyWith( racket: r ) ) )
      );
    });
  }
}
