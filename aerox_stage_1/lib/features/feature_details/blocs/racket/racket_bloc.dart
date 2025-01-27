import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/get_rackets_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'racket_event.dart';
part 'racket_state.dart';

class RacketBloc extends Bloc<RacketEvent, RacketState> {


  final GetRacketsUsecase getRacketsUsecase;

  RacketBloc({
    required this.getRacketsUsecase,
  }) : super(RacketState()){
    on<OnGetRackets>((event, emit) async{
      // ignore: avoid_single_cascade_in_expression_statements
      await getRacketsUsecase( true )..fold(
        (l)=>  emit(state.copyWith( rackets: null )) , 
        (r)=> emit( state.copyWith( rackets: r ) )
      );
    },);

    on<OnSelectRacket>((event, emit) {
      emit( state.copyWith( myRacket: event.racket ) );
    },);
    on<OnDeselectRacket>((event, emit) {
      emit( state.copyWith( myRacket: null) );
    },);
  }

}