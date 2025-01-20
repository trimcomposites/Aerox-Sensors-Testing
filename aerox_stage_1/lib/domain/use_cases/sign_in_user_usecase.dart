
import 'package:aerox_stage_1/domain/use_cases/email_sign_in_type.dart';
import 'package:aerox_stage_1/domain/user_data.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/login_repository.dart';

class SignInUserUsecase {


  signInUser( { required EmailSignInType signInType, UserData? userData }){

    final user = LoginRepository().signInUser( signInType: signInType, userData: userData );
    return user;

  }


}
