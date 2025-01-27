import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/deselect_racket_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/get_rackets_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/select_racket_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'racket_event.dart';
part 'racket_state.dart';

class RacketBloc extends Bloc<RacketEvent, RacketState> {


  final GetRacketsUsecase getRacketsUsecase;
  final SelectRacketUsecase selectRacketUsecase;
  final DeselectRacketUsecase deselectRacketUsecase;

  RacketBloc({
    required this.getRacketsUsecase,
    required this.selectRacketUsecase,
    required this.deselectRacketUsecase
  }) : super(RacketState()){
    on<OnGetRackets>((event, emit) async{
      // ignore: avoid_single_cascade_in_expression_statements
      await getRacketsUsecase( false )..fold(
        (l)=>  emit(state.copyWith( rackets: null )) , 
        (r)=> emit( state.copyWith( rackets: r ) )
      );
    },);

    on<OnSelectRacket>((event, emit) async{
      // ignore: avoid_single_cascade_in_expression_statements
      await selectRacketUsecase( event.racket )..fold(
        (l) => emit( state.copyWith( myRacket: null )),
        (r) => emit( state.copyWith( myRacket: r ))
      );
      emit( state.copyWith( myRacket: event.racket ) );
    },);
    on<OnDeselectRacket>((event, emit)async{
      // ignore: avoid_single_cascade_in_expression_statements
      await deselectRacketUsecase()..fold(
      (l) => emit( state.copyWith( myRacket: null) ),
      (r) => emit( state.copyWith( myRacket: null ) )
      );
    },);
  }

}