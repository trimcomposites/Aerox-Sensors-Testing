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
    selectRacketUsecase= MockSelectRacketUseCase();
    deselectRacketUsecase= MockUnSelectRacketUseCase();
    getSelectedRacketUsecase= MockGetSelectedRacketUseCase();
    racketBloc = RacketBloc(
      getRacketsUsecase: getRacketsUsecase,
      selectRacketUsecase: selectRacketUsecase,
      deselectRacketUsecase: deselectRacketUsecase,
      getSelectedRacketUsecase: getSelectedRacketUsecase
      );
  });


  tearDown( () => racketBloc.close() );


  final RacketErr racketErr = RacketErr(errMsg: 'errMsg', statusCode: 1);
    final Racket racket = Racket( acorMax: 1, acorMin: 1, balanceMax: 1, balanceMin: 1, maneuverabilityMax: 1, maneuverabilityMin: 1,
   swingWeightMax: 1, swingWeightMin: 1, weightMax: 1, weightMin: 1, isSelected: true, id: 1, hit: '', 
   racket: '', racketName: '', color: '', weightNumber: 1, weightName: '', weightType: '', balance: 1, headType: '', swingWeight: 1,
   powerType: '', acor: 1, acorType: '', maneuverability: 1, maneuverabilityType: '', image: ''  );

  final List<Racket> rackets = [ racket, racket ];
group('on get racket event', () {
    blocTest<RacketBloc, RacketState>(
      'on get rackets success, emits [loading, success]',
      build: () {
        when(() => getRacketsUsecase())
            .thenAnswer((_) async => Right(rackets));
        return RacketBloc(
          getRacketsUsecase: getRacketsUsecase,
          selectRacketUsecase: selectRacketUsecase,
          deselectRacketUsecase: deselectRacketUsecase,
          getSelectedRacketUsecase: getSelectedRacketUsecase,
        );
      },
      act: (bloc) => bloc.add(OnGetRackets()),
      expect: () => [
        RacketState(rackets: [], uiState: UIState.loading()),
        RacketState(rackets: rackets, uiState: UIState.idle()),
      ],
    );

    blocTest<RacketBloc, RacketState>(
      'on get rackets failure, emits [loading, error]',
      build: () {
        when(() => getRacketsUsecase())
            .thenAnswer((_) async => Left(racketErr));
        return RacketBloc(
          getRacketsUsecase: getRacketsUsecase,
          selectRacketUsecase: selectRacketUsecase,
          deselectRacketUsecase: deselectRacketUsecase,
          getSelectedRacketUsecase: getSelectedRacketUsecase,
        );
      },
      act: (bloc) => bloc.add(OnGetRackets()),
      expect: () => [
        RacketState(rackets: [], uiState: UIState.loading()),
        RacketState(rackets: [], uiState: UIState.idle()),
      ],
    );
  });

  group('on select racket event', () {
    blocTest<RacketBloc, RacketState>(
      'on select racket success, emits [myRacket: Racket]',
      build: () {
        when(() => selectRacketUsecase(racket))
            .thenAnswer((_) async => Right(racket));
        return RacketBloc(
          getRacketsUsecase: getRacketsUsecase,
          selectRacketUsecase: selectRacketUsecase,
          deselectRacketUsecase: deselectRacketUsecase,
          getSelectedRacketUsecase: getSelectedRacketUsecase,
        );
      },
      act: (bloc) => bloc.add(OnSelectRacket(racket: racket)),
      expect: () => [
        RacketState( rackets: [], uiState: UIState.loading( ) ),
       RacketState( myRacket: racket, uiState: UIState.success( next: '/home' ) ),
      ],
    );
  });

  group('on deselect racket event', () {
    blocTest<RacketBloc, RacketState>(
      'on deselect racket success, emits [myRacket: null]',
      build: () {
        when(() => deselectRacketUsecase())
            .thenAnswer((_) async => Right(null));
        return RacketBloc(
          getRacketsUsecase: getRacketsUsecase,
          selectRacketUsecase: selectRacketUsecase,
          deselectRacketUsecase: deselectRacketUsecase,
          getSelectedRacketUsecase: getSelectedRacketUsecase,
        );
      },
      act: (bloc) => bloc.add(OnUnSelectRacket()),
      expect: () => [
        RacketState(myRacket: null, uiState: UIState.loading( )),
        RacketState(myRacket: null, uiState: UIState.success( next: '/home' )),
      ],
    );
  });

  group('on get selected racket event', () {
    blocTest<RacketBloc, RacketState>(
      'on get selected racket success, emits [myRacket: Racket]',
      build: () {
        when(() => getSelectedRacketUsecase())
            .thenAnswer((_) async => Right(racket));
        return RacketBloc(
          getRacketsUsecase: getRacketsUsecase,
          selectRacketUsecase: selectRacketUsecase,
          deselectRacketUsecase: deselectRacketUsecase,
          getSelectedRacketUsecase: getSelectedRacketUsecase,
        );
      },
      act: (bloc) => bloc.add(OnGetSelectedRacket()),
      expect: () => [
        RacketState(myRacket: null, uiState: UIState.loading()),
        RacketState(myRacket: racket, uiState: UIState.idle()),
      ],
    );

    blocTest<RacketBloc, RacketState>(
      'on get selected racket failure, emits [myRacket: null]',
      build: () {
        when(() => getSelectedRacketUsecase())
            .thenAnswer((_) async => Left(racketErr));
        return RacketBloc(
          getRacketsUsecase: getRacketsUsecase,
          selectRacketUsecase: selectRacketUsecase,
          deselectRacketUsecase: deselectRacketUsecase,
          getSelectedRacketUsecase: getSelectedRacketUsecase,
        );
      },
      act: (bloc) => bloc.add(OnGetSelectedRacket()),
      expect: () => [
        RacketState(myRacket: null, uiState: UIState.loading()),
        RacketState(myRacket: null, uiState: UIState.error(racketErr.errMsg)),
      ],
    );
  });
}