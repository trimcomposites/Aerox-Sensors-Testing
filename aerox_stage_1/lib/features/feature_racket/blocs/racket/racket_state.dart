part of 'racket_bloc.dart';

class RacketState extends Equatable {

  final Racket? myRacket;
  final List<Racket> rackets;

  RacketState({
    this.myRacket,
    this.rackets = const [],
  });

  
  RacketState copyWith({
    Racket? myRacket,
    List<Racket>? rackets,
    bool? isLoading
  }) {
    return RacketState(
      myRacket: myRacket,
      rackets: rackets ?? this.rackets,
    );
  }


  @override
  List<Object?> get props => [rackets, myRacket, ];
}