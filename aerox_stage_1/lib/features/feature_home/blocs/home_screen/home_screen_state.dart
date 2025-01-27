part of 'home_screen_bloc.dart';

class HomeScreenState extends Equatable {
  final Racket? myRacket;
  const HomeScreenState({
    this.myRacket
  });
  
  copyWith({
    Racket? racket
  }) => HomeScreenState(
    myRacket: racket
  );
  
  @override
  List<Object> get props => [];
}

