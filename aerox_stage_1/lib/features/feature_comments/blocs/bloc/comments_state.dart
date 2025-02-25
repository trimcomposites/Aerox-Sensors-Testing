part of 'comments_bloc.dart';

class CommentsState extends Equatable {

  final List<Comment> comments;
  final UIState uistate;
  final AeroxUser? user;
  final Racket? racket;
  final String city;


  const CommentsState( {
    this.comments = const [], 
    required  this.uistate,
    this.user,
    this.racket,
    this.city = '...'
  });
  CommentsState copyWith({
    List<Comment>? comments,
    UIState? uistate,
    AeroxUser? user,
    Racket? racket,
    String? city
  }) {
    return CommentsState(
      comments: comments ?? this.comments,
      uistate: uistate ?? this.uistate,
      user: user ?? this.user,
      racket: racket ?? this.racket,
      city: city ?? this.city
    );
  }
  
  @override
  List<Object?> get props => [ comments, uistate, user, racket, city ];
}


