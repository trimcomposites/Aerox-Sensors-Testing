part of 'select_screen_bloc.dart';

sealed class SelectScreenEvent extends Equatable {
  const SelectScreenEvent();

  @override
  List<Object> get props => [];
}

class OnGetRacketsSelect  extends SelectScreenEvent{}
class OnSelectRacketSelect  extends SelectScreenEvent{
  final Racket racket;

  OnSelectRacketSelect({required this.racket});
}