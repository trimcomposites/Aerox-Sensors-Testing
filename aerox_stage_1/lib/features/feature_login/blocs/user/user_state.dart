part of 'user_bloc.dart';

class UserState extends Equatable {

  final AeroxUser? user;
   final String? errorMessage;

  UserState({
    this.user, 
    this.errorMessage
  });

  
  UserState copyWith({
    AeroxUser? user,
    bool? isLoading,
    String? errorMessage,
  }) {
    return UserState(
      user: user,
      errorMessage: errorMessage
    );
  }


  @override
  List<Object?> get props => [user, errorMessage];
}