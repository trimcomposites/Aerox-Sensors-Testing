part of 'select_screen_bloc.dart';

class SelectScreenState extends Equatable {
  final List<Racket> rackets;
  final UIState uiState;

  const SelectScreenState({ this.rackets = const [], required this.uiState});

  @override
  List<Object?> get props => [rackets, uiState];

  // Método copyWith
  SelectScreenState copyWith({
    List<Racket>? rackets,
    UIState? uiState,
  }) {
    return SelectScreenState(
      rackets: rackets ?? this.rackets, 
      uiState: uiState ?? this.uiState, 
    );
  }
}
