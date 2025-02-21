part of '3d_bloc.dart';

 class Model3DEvent extends Equatable {
  const Model3DEvent();


  @override
  List<Object> get props => [];
}
class OnStartLoadingModel3d extends Model3DEvent {}
class OnStopLoadingModel3d extends Model3DEvent {}
class OnStartErrorModel3d extends Model3DEvent {}