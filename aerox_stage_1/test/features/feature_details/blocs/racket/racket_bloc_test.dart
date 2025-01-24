import 'package:aerox_stage_1/common/utils/error/err/racket_err.dart';
import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/get_rackets_usecase.dart';
import 'package:aerox_stage_1/features/feature_details/blocs/racket/racket_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mock_types.dart';

late RacketBloc racketBloc;
late GetRacketsUsecase getRacketsUsecase;
void main() {

  setUp((){
    getRacketsUsecase = MockGetRacketsUseCase();
    racketBloc = RacketBloc(
      getRacketsUsecase: getRacketsUsecase,

      );
  });

  final List<Racket> rackets = [];
  final RacketErr racketErr = RacketErr(errMsg: 'errMsg', statusCode: 1);
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
    blocTest<RacketBloc, RacketState>('on get rackets success, emits [ rackets: [ List<Racket> ]', 
      build: () {
        when(() => getRacketsUsecase( true))
        .thenAnswer( ( _ ) async => Left(  racketErr ) );
        return racketBloc;
      },
      act: (bloc) => bloc.add( OnGetRackets() ),
      
      expect: () => [
        RacketState( rackets: null ),
      ],
    );
  });

}