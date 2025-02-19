part of 'home_screen_bloc.dart';

sealed class HomeScreenEvent extends Equatable {
  const HomeScreenEvent();


  @override
  List<Object> get props => [];
}
class OnGetSelectedRacketHome extends HomeScreenEvent{}

class OnStartLoadingHome extends HomeScreenEvent {}
class OnStopLoadingHome extends HomeScreenEvent {}

class OnOperationSuccessHome extends HomeScreenEvent {}

class OnStartErrorHome extends HomeScreenEvent {
  final String errorMessage;

  const OnStartErrorHome({required this.errorMessage});

}
class OnStopErrorHome extends HomeScreenEvent {}