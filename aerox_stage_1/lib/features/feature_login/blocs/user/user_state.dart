part of 'user_bloc.dart';

class UserState extends Equatable {

  final User? user;
   final String? errorMessage;

  UserState({
    this.user, 
    this.errorMessage
  });

  
  UserState copyWith({
    User? user,
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