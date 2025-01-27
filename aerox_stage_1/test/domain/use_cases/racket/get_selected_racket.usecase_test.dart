import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/common/utils/error/err/racket_err.dart';
import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/get_rackets_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/get_selected_racket.usecase.dart';
import 'package:aerox_stage_1/features/feature_racket/repository/remote/racket_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mock_types.dart';

late RacketRepository repository;
late GetSelectedRacketUsecase getSelectedRacketUsecase;
void main() {

  setUp((){
    repository = MockRacketRepository();
    getSelectedRacketUsecase = GetSelectedRacketUsecase(racketRepository: repository );
  });

  final Racket racket = Racket(name: 'name', length: 1, weight: 1, img: '' , pattern: '', balance: 1);
  final RacketErr racketErr = RacketErr(errMsg: 'errMsg', statusCode: 1);
  group('get select racket usecase ...', ()  {
    test('get selected racket success, must return a [ Racket ]', () async{
      when(()
        => repository.getSelectedRacket()
      ).thenAnswer( ( _ ) async => Right( racket ));

      final result = await getSelectedRacketUsecase();

      expect(result, isA<Right<Err, Racket>>());
    });
  });
    test('get selected racket failure, must return a [ RacketErr ]', () async{
      when(()
        => repository.getSelectedRacket()
      ).thenAnswer( ( _ ) async => Left( racketErr ) );

      final result = await getSelectedRacketUsecase();

      expect(result, isA<Left<Err, Racket>>());
  });
}