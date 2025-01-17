
import 'package:aerox_stage_1/domain/use_cases/email_sign_in_type.dart';
import 'package:aerox_stage_1/domain/user_data.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/sign_in_datasource.dart';

class SignInUserUsecase {


  signInUser( { required EmailSignInType signInType, UserData? userData }){

    final user = SignInDatasource().signInUser(signInType, userData );
    return user;

  }


}
