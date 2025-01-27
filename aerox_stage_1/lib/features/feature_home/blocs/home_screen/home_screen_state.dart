part of 'home_screen_bloc.dart';

sealed class HomeScreenState extends Equatable {
  const HomeScreenState();
  
  @override
  List<Object> get props => [];
}

final class HomeScreenInitial extends HomeScreenState {}
