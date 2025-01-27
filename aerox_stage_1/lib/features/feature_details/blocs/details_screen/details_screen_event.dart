part of 'details_screen_bloc.dart';

sealed class DetailsScreenEvent extends Equatable {
  const DetailsScreenEvent();

  @override
  List<Object> get props => [];
}

class OnStartDetailsScreenLoading extends DetailsScreenEvent{}
class OnStopDetailsScreenLoading extends DetailsScreenEvent{}

class OnStartDetailsScreenError extends DetailsScreenEvent{}
class OnStopDetailsScreenError extends DetailsScreenEvent{}