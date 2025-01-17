import 'package:aerox_stage_1/domain/use_cases/email_sign_in_type.dart';
import 'package:aerox_stage_1/domain/user_data.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/email_auth_service.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/google_auth_service.dart';

class SignInDatasource{
  signInUser( EmailSignInType signInType, UserData? userData ) async{
    switch( signInType ){
      case EmailSignInType.email:
      return await EmailAuthService.signInWithEmail(userData: userData! );
      case EmailSignInType.google:
        return await GoogleAuthService().signInWithGoogle();
        throw UnimplementedError();
      case EmailSignInType.apple:
        // TODO: Handle this case.
        throw UnimplementedError();
      case EmailSignInType.meta:
        // TODO: Handle this case.
        throw UnimplementedError();
    }


  }
}