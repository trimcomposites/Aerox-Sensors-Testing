import 'package:aerox_stage_1/common/utils/error/err/racket_err.dart';
import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/deselect_racket_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/get_rackets_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/get_selected_racket.usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/select_racket_usecase.dart';
import 'package:aerox_stage_1/features/feature_racket/blocs/racket/racket_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mock_types.dart';

late RacketBloc racketBloc;
late GetRacketsUsecase getRacketsUsecase;
late SelectRacketUsecase selectRacketUsecase;
late DeselectRacketUsecase deselectRacketUsecase;
late GetSelectedRacketUsecase getSelectedRacketUsecase;
void main() {

  setUp((){
    getRacketsUsecase = MockGetRacketsUseCase();
    racketBloc = RacketBloc(
      getRacketsUsecase: getRacketsUsecase,
      selectRacketUsecase: selectRacketUsecase,
      deselectRacketUsecase: deselectRacketUsecase,
      getSelectedRacketUsecase: getSelectedRacketUsecase
      );
  });

  final List<Racket> rackets = [];
  final RacketErr racketErr = RacketErr(errMsg: 'errMsg', statusCode: 1);
  final Racket racket = Racket(id: 1, name: 'name', length: 1, weight: 1, img: 'img', pattern: 'pattern', balance: 1);
  group(' on get racket event ...', () {
    blocTest<RacketBloc, RacketState>('on get rackets success, emits [ rackets: [ List<Racket> ]', 
      build: () {
        when(() => getRacketsUsecase( true))
        .thenAnswer( ( _ ) async => Right(  rackets ) );
        return racketBloc;
      },
      act: (bloc) => bloc.add( OnGetRackets() ),
      
      expect: () => [
        RacketState( rackets: rackets ),
      ],
    );
    blocTest<RacketBloc, RacketState>('on get rackets failure, emits [ rackets: [ List<Racket>.empty ]', 
      build: () {
        when(() => getRacketsUsecase( true))
        .thenAnswer( ( _ ) async => Left(  racketErr ) );
        return racketBloc;
      },
      act: (bloc) => bloc.add( OnGetRackets() ),
      
      expect: () => [
        RacketState( rackets: [] ),
      ],
    );
  });
  
  group(('on select racket event'), (){
    blocTest<RacketBloc, RacketState>('on select rackets success, emits [ myRacket: [ Racket ]', 
      build: () => racketBloc,
      
      act: (bloc) => bloc.add( OnSelectRacket( racket: racket ) ),
      
      expect: () => [
        RacketState( myRacket: racket ),
      ],
    );
    blocTest<RacketBloc, RacketState>('on Deselect rackets success, emits [ myRacket: [ Racket ]', 
      build: () => racketBloc,
      
      act: (bloc) => bloc.add( OnDeselectRacket() ),
      
      expect: () => [
        RacketState( myRacket: null ),
      ],
    );

  group(('on get selected racket event'), (){
    blocTest<RacketBloc, RacketState>('on get selected racket success, emits [ myRacket: [ Racket ]', 
      build: () {
        when(() => getSelectedRacketUsecase( ))
        .thenAnswer( ( _ ) async => Right(  racket ) );
        return racketBloc;
      },
      act: (bloc) => bloc.add( OnGetSelectedRacket() ),
      
      expect: () => [
        RacketState( myRacket: racket ),
      ],
    );
    blocTest<RacketBloc, RacketState>('on get selected racket failure, emits [ myRacket: [ null ]', 
      build: () {
        when(() => getSelectedRacketUsecase( ))
        .thenAnswer( ( _ ) async => Left(  racketErr ) );
        return racketBloc;
      },
      act: (bloc) => bloc.add( OnGetSelectedRacket() ),
      
      expect: () => [
        RacketState( myRacket: null ),
      ],
    );
  });
});
}