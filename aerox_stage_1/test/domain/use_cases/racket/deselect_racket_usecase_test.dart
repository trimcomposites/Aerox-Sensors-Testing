import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/common/utils/error/err/racket_err.dart';
import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/unselect_racket_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/select_racket_usecase.dart';
import 'package:aerox_stage_1/features/feature_racket/repository/racket_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mock_types.dart';

late RacketRepository repository;
late UnSelectRacketUseCase deselectRacketUsecase;
void main() {

  setUp((){
    repository = MockRacketRepository();
    deselectRacketUsecase = UnSelectRacketUseCase(racketRepository: repository );
  });

  final Racket racket = any( named: 'racket' );
  final RacketErr racketErr = RacketErr(errMsg: 'errMsg', statusCode: 1);
  group(' select racket usecase ...', ()  {
    test(' select racket success, must return a [ Racket ]', () async{
      when(()
        => repository.deselectRacket()
      ).thenAnswer( ( _ ) async => Right( null ));

      final result = await deselectRacketUsecase();

      expect(result, isA<Right<Err, void>>());
    });
  });
    test('select racket failure, must return a [ RacketErr ]', () async{
      when(()
        => repository.deselectRacket()
      ).thenAnswer( ( _ ) async => Left( racketErr ) );

      final result = await deselectRacketUsecase( );

      expect(result, isA<Left<Err, void>>());
  });
}