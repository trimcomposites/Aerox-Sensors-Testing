import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/common/utils/error/err/racket_err.dart';
import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/unselect_racket_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/get_rackets_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/get_selected_racket_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/select_racket_usecase.dart';
import 'package:aerox_stage_1/features/feature_details/blocs/details_screen/details_screen_bloc.dart';
import 'package:aerox_stage_1/features/feature_racket/blocs/racket/racket_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mock_types.dart';
import '../racket/racket_bloc_test.dart';

late DetailsScreenBloc detailsScreenBloc;
late GetSelectedRacketUseCase getSelectedRacketUsecase;
late UnSelectRacketUseCase unSelectRacketUseCase;
void main() {

  setUp((){
    getSelectedRacketUsecase = MockGetSelectedRacketUseCase();
    unSelectRacketUseCase = MockUnSelectRacketUseCase();
    detailsScreenBloc = DetailsScreenBloc(
      getSelectedRacketUsecase: getSelectedRacketUsecase,
      unSelectRacketUseCase: unSelectRacketUseCase
      );
  });
  tearDown( () => detailsScreenBloc.close() );
  final List<Racket> rackets = [];

  final RacketErr racketErr = RacketErr(errMsg: 'errMsg', statusCode: 1);
  final Racket racket = Racket( acorMax: 1, acorMin: 1, balanceMax: 1, balanceMin: 1, maneuverabilityMax: 1, maneuverabilityMin: 1,
   swingWeightMax: 1, swingWeightMin: 1, weightMax: 1, weightMin: 1, isSelected: true, id: 1, hit: '', 
   frame: '', racketName: '', color: '', weightNumber: 1, weightName: '', weightType: '', balance: 1, headType: '', swingWeight: 1,
   powerType: '', acor: 1, acorType: '', maneuverability: 1, maneuverabilityType: '', image: '', model: ''  );

  group(('on get selected racket event'), (){
      blocTest<DetailsScreenBloc, DetailsScreenState>('on get selected racket success, emits [ myRacket: [ Racket ]', 
        build: () {
          when(() => getSelectedRacketUsecase( ))
          .thenAnswer( ( _ ) async => Right(  racket ) );
          return detailsScreenBloc;
        },
        act: (bloc) => bloc.add( OnGetSelectedRacketDetails() ),
        
        expect: () => [
          DetailsScreenState( racket: null, uiState: UIState.loading() ),
          DetailsScreenState( racket: racket, uiState: UIState.success() ),
        ],
      );
      blocTest<DetailsScreenBloc, DetailsScreenState>('on get selected racket failure, emits [ myRacket: [ null ]', 
        build: () {
          when(() => getSelectedRacketUsecase( ))
          .thenAnswer( ( _ ) async => Left(  racketErr ) );
          return detailsScreenBloc;
        },
        act: (bloc) => bloc.add( OnGetSelectedRacketDetails() ),
        
        expect: () => [
          DetailsScreenState( racket: null, uiState: UIState.loading()),
          DetailsScreenState( racket: null, uiState: UIState.error( 'errMsg' )),
        ],
      );
    blocTest<DetailsScreenBloc, DetailsScreenState>('on Deselect rackets success, emits [ myRacket: [ Racket ]', 
        build: () {
          when(() => unSelectRacketUseCase( ))
          .thenAnswer( ( _ ) async => Right(  null ) );
          return detailsScreenBloc;
        },
      act: (bloc) => bloc.add( OnUnSelectRacketDetails() ),
      
      expect: () => [
        DetailsScreenState( racket: null,uiState: UIState.loading() ),
        DetailsScreenState( racket: null,uiState: UIState.success( next: '/home' ) ),
      ],
    );

  });
}
