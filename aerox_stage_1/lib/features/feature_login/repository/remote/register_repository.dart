import 'package:aerox_stage_1/domain/user_data.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/email_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterRepository {

  registerWithEmail( UserData userData ) async{
    final user = await EmailAuthService.createUserWithEmail( userData: userData );
    return user;
  }


}