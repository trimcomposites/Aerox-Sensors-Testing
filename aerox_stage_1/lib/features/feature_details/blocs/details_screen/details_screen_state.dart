part of 'details_screen_bloc.dart';

class DetailsScreenState extends Equatable {
  final Racket? racket;
  final UIState uiState;

  const DetailsScreenState({ this.racket, required this.uiState});

  @override
  List<Object?> get props => [racket, uiState];

  // Método copyWith
  DetailsScreenState copyWith({
    Racket? racket,
    UIState? uiState,
  }) {
    return DetailsScreenState(
      racket: racket, 
      uiState: uiState ?? this.uiState, 
    );
  }
}
