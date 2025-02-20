part of 'racket_bloc.dart';

class RacketState extends Equatable {

  final Racket? myRacket;
  final List<Racket> rackets;
  final UIState uiState;

  RacketState({
    this.myRacket,
    this.rackets = const [],
    required this.uiState
  });

  
  RacketState copyWith({
    Racket? myRacket,
    List<Racket>? rackets,
    UIState? uiState
  }) {
    return RacketState(
      myRacket: myRacket,
      rackets: rackets ?? this.rackets,
      uiState: uiState ?? this.uiState
    );
  }


  @override
  List<Object?> get props => [rackets, myRacket, uiState];
}