import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/common/utils/error/err/racket_err.dart';
import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/get_selected_racket_usecase.dart';
import 'package:aerox_stage_1/features/feature_home/blocs/home_screen/home_screen_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mock_types.dart';

late HomeScreenBloc homeScreenBloc;
late GetSelectedRacketUseCase getSelectedRacketUsecase;

void main() {
  setUp(() {
    getSelectedRacketUsecase = MockGetSelectedRacketUseCase();
    homeScreenBloc = HomeScreenBloc(
      getSelectedRacketUsecase: getSelectedRacketUsecase,
    );
  });

  tearDown(() {
    homeScreenBloc.close();
  });

  final RacketErr racketErr = RacketErr(errMsg: '', statusCode: 500);
  final Racket racket = Racket( acorMax: 1, acorMin: 1, balanceMax: 1, balanceMin: 1, maneuverabilityMax: 1, maneuverabilityMin: 1,
   swingWeightMax: 1, swingWeightMin: 1, weightMax: 1, weightMin: 1, isSelected: true, id: 1, hit: '', 
   frame: '', racketName: '', color: '', weightNumber: 1, weightName: '', weightType: '', balance: 1, headType: '', swingWeight: 1,
   powerType: '', acor: 1, acorType: '', maneuverability: 1, maneuverabilityType: '', image: ''  );

  group('🔹 HomeScreenBloc - OnGetSelectedRacketHome', () {
    blocTest<HomeScreenBloc, HomeScreenState>(
      ' Emite [loading, success] ',
      build: () {
        when(() => getSelectedRacketUsecase())
            .thenAnswer((_) async => Right(racket));
        return homeScreenBloc;
      },
      act: (bloc) => bloc.add(OnGetSelectedRacketHome()),
      expect: () => [
        HomeScreenState(myRacket: null, uiState: UIState.loading()),
        HomeScreenState(myRacket: racket, uiState: UIState.success()),
      ],
    );

    blocTest<HomeScreenBloc, HomeScreenState>(
      'Emits [loading, error] ',
      build: () {
        when(() => getSelectedRacketUsecase())
            .thenAnswer((_) async => Left(racketErr));
        return homeScreenBloc;
      },
      act: (bloc) => bloc.add(OnGetSelectedRacketHome()),
      expect: () => [
        HomeScreenState(myRacket: null, uiState: UIState.loading()),
        HomeScreenState(myRacket: null, uiState: UIState.error(racketErr.errMsg)),
      ],
    );
  });
}
