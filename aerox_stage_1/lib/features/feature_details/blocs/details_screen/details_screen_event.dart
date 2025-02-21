part of 'details_screen_bloc.dart';

sealed class DetailsScreenEvent extends Equatable {
  const DetailsScreenEvent();

  @override
  List<Object> get props => [];
}

class OnGetSelectedRacketDetails  extends DetailsScreenEvent{}
class OnUnSelectRacketDetails  extends DetailsScreenEvent{}