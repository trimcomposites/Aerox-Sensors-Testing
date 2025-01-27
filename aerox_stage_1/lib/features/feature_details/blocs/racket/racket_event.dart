part of 'racket_bloc.dart';

class RacketEvent extends Equatable {
  const RacketEvent();

  @override
  List<Object> get props => [];
}

class OnGetRackets extends RacketEvent {
  
}
class OnSelectRacket extends RacketEvent {
  final Racket racket;

  OnSelectRacket({required this.racket});
}
class OnDeselectRacket extends RacketEvent {}

class OnStartRacketLoading extends RacketEvent{}
class OnStopRacketLoading extends RacketEvent{}