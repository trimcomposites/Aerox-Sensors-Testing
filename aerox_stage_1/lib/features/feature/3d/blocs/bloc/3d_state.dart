part of '3d_bloc.dart';

class Model3DState extends Equatable {
  final UIState uiState;

  const Model3DState({
    required this.uiState
  });

  Model3DState copyWith({
    UIState? uiState
  }) {
    return Model3DState(
      uiState: uiState ?? this.uiState,
    );
  }

  @override
  List<Object> get props => [uiState];
}