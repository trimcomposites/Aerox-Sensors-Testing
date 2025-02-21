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

  final List<Racket> rackets = [];
  final RacketErr racketErr = RacketErr(errMsg: 'errMsg', statusCode: 1);
  final Racket racket = any( named: 'racket' );

  group(('on get selected racket event'), (){
      blocTest<DetailsScreenBloc, DetailsScreenState>('on get selected racket success, emits [ myRacket: [ Racket ]', 
        build: () {
          when(() => getSelectedRacketUsecase( ))
          .thenAnswer( ( _ ) async => Right(  racket ) );
          return detailsScreenBloc;
        },
        act: (bloc) => bloc.add( OnGetSelectedRacketDetails() ),
        
        expect: () => [
          RacketState( myRacket: null, uiState: UIState.success() ),
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
          RacketState( myRacket: null, uiState: UIState.error( any() ) ),
        ],
      );
          blocTest<DetailsScreenBloc, DetailsScreenState>('on Deselect rackets success, emits [ myRacket: [ Racket ]', 
      build: () => detailsScreenBloc,
      
      act: (bloc) => bloc.add( OnUnSelectRacketDetails() ),
      
      expect: () => [
        RacketState( myRacket: null,uiState: UIState.success() ),
      ],
    );

  });
}
