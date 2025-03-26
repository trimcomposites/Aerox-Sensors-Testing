import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/features/feature_3d/blocs/bloc/3d_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Model3DBloc model3DBloc;

  setUp(() {
    model3DBloc = Model3DBloc();
  });

  tearDown(() {
    model3DBloc.close();
  });

  group('Model3DBloc events', () {
    blocTest<Model3DBloc, Model3DState>(
      'emits [loading] when OnStartLoadingModel3d is added',
      build: () => model3DBloc,
      act: (bloc) => bloc.add(OnStartLoadingModel3d()),
      expect: () => [
        Model3DState(uiState: UIState.loading()),
      ],
    );

    blocTest<Model3DBloc, Model3DState>(
      'emits [success] when OnStopLoadingModel3d is added',
      build: () => model3DBloc,
      act: (bloc) => bloc.add(OnStopLoadingModel3d()),
      expect: () => [
        Model3DState(uiState: UIState.success()),
      ],
    );

    blocTest<Model3DBloc, Model3DState>(
      'emits [error] with message when OnStartErrorModel3d is added',
      build: () => model3DBloc,
      act: (bloc) => bloc.add(OnStartErrorModel3d(errormsg: 'Error loading model')),
      expect: () => [
        Model3DState(uiState: UIState.error('Error loading model')),
      ],
    );
  });
}
