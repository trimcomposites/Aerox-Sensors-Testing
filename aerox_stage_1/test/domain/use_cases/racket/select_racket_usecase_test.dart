import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/common/utils/error/err/racket_err.dart';
import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/select_racket_usecase.dart';
import 'package:aerox_stage_1/features/feature_racket/repository/racket_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mock_types.dart';

late RacketRepository repository;
late SelectRacketUseCase selectRacketUsecase;
void main() {

  setUp((){
    repository = MockRacketRepository();
    selectRacketUsecase = SelectRacketUseCase(racketRepository: repository );
  });

 final Racket racket = Racket( acorMax: 1, acorMin: 1, balanceMax: 1, balanceMin: 1, maneuverabilityMax: 1, maneuverabilityMin: 1,
   swingWeightMax: 1, swingWeightMin: 1, weightMax: 1, weightMin: 1, isSelected: true, id: 1, hit: '', 
   frame: '', racketName: '', color: '', weightNumber: 1, weightName: '', weightType: '', balance: 1, headType: '', swingWeight: 1,
   powerType: '', acor: 1, acorType: '', maneuverability: 1, maneuverabilityType: '', image: '', model: ''  );
  final RacketErr racketErr = RacketErr(errMsg: 'errMsg', statusCode: 1);
  group(' select racket usecase ...', ()  {
    test(' select racket success, must return a [ Racket ]', () async{
      when(()
        => repository.selectRacket( racket )
      ).thenAnswer( ( _ ) async => Right( racket ));

      final result = await selectRacketUsecase( racket );

      expect(result, isA<Right<Err, Racket>>());
    });
  });
    test('select racket failure, must return a [ RacketErr ]', () async{
      when(()
        => repository.selectRacket( racket )
      ).thenAnswer( ( _ ) async => Left( racketErr ) );

      final result = await selectRacketUsecase( racket );

      expect(result, isA<Left<Err, Racket>>());
  });
}