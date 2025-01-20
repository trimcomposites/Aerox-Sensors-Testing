import 'package:aerox_stage_1/domain/use_cases/use_case.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/sign_in_datasource.dart';

import 'email_sign_in_type.dart';

class SignOutUserUsecase extends UseCase<void, EmailSignInType>{

  const SignOutUserUsecase( { required this.signInType } );
  final EmailSignInType signInType;
  @override
  call() {
    SignInDatasource().signOutUser( signInType: signInType );
  }


}
