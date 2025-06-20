import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/get_selected_racket_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_screen_event.dart';
part 'home_screen_state.dart';


class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  final GetSelectedRacketUseCase getSelectedRacketUsecase;
  HomeScreenBloc({
    required this.getSelectedRacketUsecase,

  }) : super(HomeScreenState( uiState: UIState(status: UIStatus.success) )) {
    on<OnGetSelectedRacketHome>((event, emit) async {
      emit( state.copyWith( uiState: UIState.loading() ) );
      // ignore: avoid_single_cascade_in_expression_statements
      await getSelectedRacketUsecase()..fold(
        (l) => ( emit(state.copyWith( racket: null, uiState: UIState.error( l.errMsg ) )) ),
        (r) => ( emit( state.copyWith( racket: r, uiState: UIState.success() )))
      );
    });
    on<OnChangeHomeTab>((event, emit) {
      emit(state.copyWith(selectedTab: event.tab));
    });

  }
  

  
}
