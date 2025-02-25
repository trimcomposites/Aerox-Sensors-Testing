part of 'comments_bloc.dart';

class CommentsState extends Equatable {

  final List<Comment> comments;
  final UIState uistate;
  final AeroxUser? user;
  final Racket? racket;


  const CommentsState( {
    this.comments = const [], 
    required  this.uistate,
    this.user,
    this.racket
  });
  CommentsState copyWith({
    List<Comment>? comments,
    UIState? uistate,
    AeroxUser? user,
    Racket? racket
  }) {
    return CommentsState(
      comments: comments ?? this.comments,
      uistate: uistate ?? this.uistate,
      user: user ?? this.user,
      racket: racket ?? this.racket
    );
  }
  
  @override
  List<Object?> get props => [ comments, uistate, user, racket ];
}


