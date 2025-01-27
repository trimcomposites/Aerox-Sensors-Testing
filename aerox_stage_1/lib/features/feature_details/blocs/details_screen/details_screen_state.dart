part of 'details_screen_bloc.dart';

sealed class DetailsScreenState extends Equatable {
  const DetailsScreenState();
  
  @override
  List<Object> get props => [];
}

final class DetailsScreenInitial extends DetailsScreenState {}
