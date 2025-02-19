import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/common/utils/error/err/racket_err.dart';
import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/get_rackets_usecase.dart';
import 'package:aerox_stage_1/features/feature_racket/repository/racket_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mock_types.dart';

late RacketRepository repository;
late GetRacketsUsecase getRacketsUsecase;
void main() {

  setUp((){
    repository = MockRacketRepository();
    getRacketsUsecase = GetRacketsUsecase(racketRepository: repository );
  });

  final List<Racket> racketList = [];
  final RacketErr racketErr = RacketErr(errMsg: 'errMsg', statusCode: 1);
  group('get rackets usecase ...', ()  {
    test('get Rackets success, must return a [ List<Racket> ]', () async{
      when(()
        => repository.getRackets(remote: any( named: 'remote' ))
      ).thenAnswer( ( _ ) async => Right( racketList ) );

      final result = await getRacketsUsecase( true );

      expect(result, isA<Right<Err, List<Racket>>>());
    });
  });
    test('get Rackets failure, must return a [ RacketErr ]', () async{
      when(()
        => repository.getRackets(remote: any( named: 'remote' ))
      ).thenAnswer( ( _ ) async => Left( racketErr ) );

      final result = await getRacketsUsecase( true );

      expect(result, isA<Left<Err, List<Racket>>>());
  });
}