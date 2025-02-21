import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/get_selected_racket_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/unselect_racket_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'details_screen_event.dart';
part 'details_screen_state.dart';

class DetailsScreenBloc extends Bloc<DetailsScreenEvent, DetailsScreenState> {
final GetSelectedRacketUseCase getSelectedRacketUsecase;
final UnSelectRacketUseCase unSelectRacketUseCase;
  DetailsScreenBloc({
    required this.getSelectedRacketUsecase,
    required this.unSelectRacketUseCase

  }) : super(DetailsScreenState( uiState: UIState.loading()  )){
        on<OnGetSelectedRacketDetails>((event, emit) async {
      emit( state.copyWith( uiState: UIState.loading() ) );
      // ignore: avoid_single_cascade_in_expression_statements
      await getSelectedRacketUsecase()..fold(
        (l) => ( emit(state.copyWith( racket: null )) ),
        (r) => ( emit( state.copyWith( racket: r, uiState: UIState.success() ) ) )
      );
    });
    on<OnUnSelectRacketDetails>((event, emit)async{
      // ignore: avoid_single_cascade_in_expression_statements
      await unSelectRacketUseCase()..fold(
      (l) => emit( state.copyWith( racket: null) ),
      (r) => emit( state.copyWith( racket: null, uiState: UIState.success( next: '/home' ) ) )
      );
    },);
  
  }
}
