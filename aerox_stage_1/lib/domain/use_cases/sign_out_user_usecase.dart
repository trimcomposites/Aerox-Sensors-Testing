import 'package:aerox_stage_1/features/feature_login/repository/remote/sign_in_datasource.dart';

import 'email_sign_in_type.dart';

class SignOutUserUsecase {


  signOutUser( { required EmailSignInType signInType } ){

    SignInDatasource().signOutUser( signInType: signInType );

  }


}
