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
  final String name;
  OnEmailRegisterUser({required this.email, required this.password, required this.name});
}
class OnCheckUserIsSignedIn extends UserEvent{
  
}

class OnDeleteErrorMsg extends UserEvent{

}
class OnEnableLogin extends UserEvent{

}
class OnDisableLogin extends UserEvent{

}

class OnPasswordReset extends UserEvent{

  final String email;

  OnPasswordReset({required this.email});

}
