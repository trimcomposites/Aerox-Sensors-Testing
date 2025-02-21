import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/common/utils/error/err/racket_err.dart';
import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/unselect_racket_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/get_rackets_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/get_selected_racket_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/select_racket_usecase.dart';
import 'package:aerox_stage_1/features/feature_racket/blocs/racket/racket_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mock_types.dart';

late RacketBloc racketBloc;
late GetRacketsUseCase getRacketsUsecase;
late SelectRacketUseCase selectRacketUsecase;
late UnSelectRacketUseCase deselectRacketUsecase;
late GetSelectedRacketUseCase getSelectedRacketUsecase;
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
  final Racket racket = any( named: 'racket' );
  group(' on get racket event ...', () {
    blocTest<RacketBloc, RacketState>('on get rackets success, emits [ rackets: [ List<Racket> ]', 
      build: () {
        when(() => getRacketsUsecase())
        .thenAnswer( ( _ ) async => Right(  rackets ) );
        return racketBloc;
      },
      act: (bloc) => bloc.add( OnGetRackets() ),
      
      expect: () => [
        RacketState( rackets: rackets, uiState: UIState.success() ),
      ],
    );
    blocTest<RacketBloc, RacketState>('on get rackets failure, emits [ rackets: [ List<Racket>.empty ]', 
      build: () {
        when(() => getRacketsUsecase())
        .thenAnswer( ( _ ) async => Left(  racketErr ) );
        return racketBloc;
      },
      act: (bloc) => bloc.add( OnGetRackets() ),
      
      expect: () => [
        RacketState( rackets: [], uiState: UIState.error( any()) ),
      ],
    );
  });
  
  group(('on select racket event'), (){
    blocTest<RacketBloc, RacketState>('on select rackets success, emits [ myRacket: [ Racket ]', 
      build: () => racketBloc,
      
      act: (bloc) => bloc.add( OnSelectRacket( racket: racket ) ),
      
      expect: () => [
        RacketState( myRacket: racket, uiState: UIState.success() ),
      ],
    );
    blocTest<RacketBloc, RacketState>('on Deselect rackets success, emits [ myRacket: [ Racket ]', 
      build: () => racketBloc,
      
      act: (bloc) => bloc.add( OnUnSelectRacket() ),
      
      expect: () => [
        RacketState( myRacket: null,uiState: UIState.success() ),
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
        RacketState( myRacket: racket, uiState: UIState.success() ),
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
        RacketState( myRacket: null, uiState: UIState.error( any() ) ),
      ],
    );
  });
});
}