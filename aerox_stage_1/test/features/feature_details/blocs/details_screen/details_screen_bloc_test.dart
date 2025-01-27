import 'package:aerox_stage_1/features/feature_details/blocs/details_screen/details_screen_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';


late DetailsScreenBloc detailScreenBloc;
void main() {

  setUp((){
    detailScreenBloc = DetailsScreenBloc();
  });
  group('loading event', () {
    blocTest<DetailsScreenBloc, DetailsScreenState>('on start loading, emits [ isLoading: [ true ]', 
      build: () => detailScreenBloc,
      act: (bloc) => bloc.add( OnStartDetailsScreenLoading() ),
      
      expect: () => [
        DetailsScreenState( isLoading: true, isError: false ),
      ],
    );
    blocTest<DetailsScreenBloc, DetailsScreenState>('on stop loading, emits [ isLoading: [ false ]', 
      build: () => detailScreenBloc,
      act: (bloc) => bloc.add( OnStopDetailsScreenLoading() ),
      
      expect: () => [
        DetailsScreenState( isLoading: false, isError: false ),
      ],
    );
  });
  group('error event', () {
    blocTest<DetailsScreenBloc, DetailsScreenState>('on start error, emits [ error: [ true ]', 
      build: () => detailScreenBloc,
      act: (bloc) => bloc.add( OnStartDetailsScreenError() ),
      
      expect: () => [
        DetailsScreenState( isLoading: false, isError: true ),
      ],
    );
    blocTest<DetailsScreenBloc, DetailsScreenState>('on stop error, emits [ error: [ false ]', 
      build: () => detailScreenBloc,
      act: (bloc) => bloc.add( OnStopDetailsScreenError() ),
      
      expect: () => [
        DetailsScreenState( isLoading: false, isError: false ),
      ],
    );
  });
}