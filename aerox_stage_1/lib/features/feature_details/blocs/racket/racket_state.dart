part of 'racket_bloc.dart';

class RacketState extends Equatable {

  final Racket? myRacket;
  final List<Racket> rackets;
  final bool isLoading;

  RacketState({
    this.myRacket,
    this.rackets = const [],
    this.isLoading = false
  });

  
  RacketState copyWith({
    Racket? myRacket,
    List<Racket>? rackets,
    bool? isLoading
  }) {
    return RacketState(
      myRacket: myRacket,
      rackets: rackets ?? this.rackets,
      isLoading: isLoading ?? this.isLoading
    );
  }


  @override
  List<Object?> get props => [rackets, myRacket, isLoading];
}