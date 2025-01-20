import 'package:aerox_stage_1/domain/use_cases/use_case.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/login_repository.dart';

import 'email_sign_in_type.dart';

class SignOutUserUsecase extends UseCase<void, EmailSignInType>{

  const SignOutUserUsecase( { required this.signInType } );
  final EmailSignInType signInType;
  @override
  call() {
    LoginRepository().signOutUser( signInType: signInType );
  }


}
