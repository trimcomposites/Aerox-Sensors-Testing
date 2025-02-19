part of 'home_screen_bloc.dart';

class HomeScreenState extends Equatable {
  final Racket? myRacket;
  final UIState uiState;
  const HomeScreenState({
    this.myRacket,
    required this.uiState, 
  });
  
  copyWith({
    Racket? racket,
    UIState? uiState
  }) => HomeScreenState(
    myRacket: racket,
    uiState: uiState ?? this.uiState
  );
  
  @override
  List<Object?> get props => [ myRacket, uiState ];
}

