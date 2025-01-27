part of 'details_screen_bloc.dart';

sealed class DetailsScreenState extends Equatable {

  const DetailsScreenState(); 
  @override
  List<Object> get props => [];
}
class IdleDetailsScreenState extends DetailsScreenState{}
class LoadingDetailsScreenState extends DetailsScreenState{}
class RacketDetailsScreenState extends DetailsScreenState{}
class RacketSelectScreenState extends DetailsScreenState{}
class ErrorDetailsScreenState extends DetailsScreenState{}


