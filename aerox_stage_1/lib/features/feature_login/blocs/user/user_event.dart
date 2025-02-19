part of 'user_bloc.dart';

class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}
class OnGoogleSignInUser extends UserEvent{
}
class OnGoogleSignOutUser extends UserEvent{
}

class OnEmailSignInUser extends UserEvent{
  final String email;
  final String password;

  OnEmailSignInUser({required this.email, required this.password});

}
class OnEmailSignOutUser extends UserEvent{
}
class OnEmailRegisterUser extends UserEvent{
  final String email;
  final String password;
  OnEmailRegisterUser({required this.email, required this.password});
}
class OnCheckUserIsSignedIn extends UserEvent{
  
}

class OnDeleteErrorMsg extends UserEvent{

}

class OnPasswordReset extends UserEvent{

  final String email;

  OnPasswordReset({required this.email});

}
class OnStartLoadingUser extends UserEvent {}

class OnStopLoadingUser extends UserEvent {}

class OnOperationSuccessUser extends UserEvent {}

class OnStartErrorUser extends UserEvent {
  final String errorMessage;

  const OnStartErrorUser({required this.errorMessage});
}

class OnStopErrorUser extends UserEvent {}