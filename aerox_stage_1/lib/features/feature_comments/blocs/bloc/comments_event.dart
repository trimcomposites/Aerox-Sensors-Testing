part of 'comments_bloc.dart';

sealed class CommentsEvent extends Equatable {
  const CommentsEvent();

  @override
  List<Object> get props => [];
}


class OnGetRacketComments extends CommentsEvent{

  final int racketId;

  OnGetRacketComments({required this.racketId});

}

class OnGetCurrentUser extends CommentsEvent{}
class OnGetSelectedRacketComments extends CommentsEvent{}
class OnGetCityLocation extends CommentsEvent{}
class OnSaveComment extends CommentsEvent{

  final Comment comment;

  OnSaveComment({required this.comment});

}