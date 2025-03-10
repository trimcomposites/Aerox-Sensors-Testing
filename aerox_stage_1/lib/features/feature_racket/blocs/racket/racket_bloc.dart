import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/unselect_racket_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/get_rackets_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/get_selected_racket_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/select_racket_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'racket_event.dart';
part 'racket_state.dart';

class RacketBloc extends Bloc<RacketEvent, RacketState> {


  final GetRacketsUseCase getRacketsUsecase;
  final SelectRacketUseCase selectRacketUsecase;
  final UnSelectRacketUseCase deselectRacketUsecase;
  final GetSelectedRacketUseCase getSelectedRacketUsecase;

  RacketBloc({
    required this.getRacketsUsecase,
    required this.selectRacketUsecase,
    required this.deselectRacketUsecase,
    required this.getSelectedRacketUsecase,
  }) : super(RacketState( uiState: UIState.idle() )){
    on<OnGetRackets>((event, emit) async{
      emit( state.copyWith( uiState: UIState.loading() ) );
      // ignore: avoid_single_cascade_in_expression_statements
      final result = await getRacketsUsecase();
      result.fold(
        (l)=>  emit(state.copyWith( rackets: null,uiState: UIState.idle() )) , 
        // ignore: unnecessary_set_literal
        (r) async {
          emit( state.copyWith( rackets: r, uiState: UIState.idle() ) );
          }
      );
    },);

    on<OnSelectRacket>((event, emit) async{
      emit( state.copyWith( uiState: UIState.loading() ) );
      // ignore: avoid_single_cascade_in_expression_statements
      await selectRacketUsecase( event.racket )..fold(
      (l) => ( emit(state.copyWith( myRacket: null , uiState: UIState.error( l.errMsg ) ))),
        (r) => emit( state.copyWith( myRacket: r, uiState: UIState.success( next: '/home' ) ))
      );
      //emit( state.copyWith( myRacket: event.racket ) );
    },);
    on<OnUnSelectRacket>((event, emit)async{
      emit( state.copyWith( uiState: UIState.loading() ) );
      // ignore: avoid_single_cascade_in_expression_statements
      await deselectRacketUsecase()..fold(
      (l) => ( emit(state.copyWith( myRacket: null , uiState: UIState.error( l.errMsg ) ))),
      (r) => emit( state.copyWith( myRacket: null, uiState: UIState.success( next: '/home' ) ) )
      );
    },);
  
  on<OnGetSelectedRacket>((event, emit) async {
    emit( state.copyWith( uiState: UIState.loading() ) );
    // ignore: avoid_single_cascade_in_expression_statements
    await getSelectedRacketUsecase()..fold(
      (l) => ( emit(state.copyWith( myRacket: null , uiState: UIState.error( l.errMsg ) ))),
      (r) => ( emit( state.copyWith( myRacket: r, uiState: UIState.idle() ) ) )
    );
  });
  }
}