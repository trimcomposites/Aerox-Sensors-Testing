part of 'racket_bloc.dart';

class RacketState extends Equatable {

  final Racket? myRacket;
   final List<Racket>? rackets;

  RacketState({
    this.myRacket,
    this.rackets
  });

  
  RacketState(copyWith({
    Racket? myRacket,
     List<Racket>? rackets,
  }) {
    return RacketState(
      myRacket: myRacket,
      rackets: rackets
    );
  }


  @override
  List<Object?> get props => [user, errorMessage];
}