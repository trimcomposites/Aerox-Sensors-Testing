import 'package:aerox_stage_1/domain/user_data.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/email_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterRepository {

  final EmailAuthService emailAuthService;

  RegisterRepository({required this.emailAuthService});

  registerWithEmail( UserData userData ) async{
    final user = await emailAuthService.createUserWithEmail( userData: userData );
    return user;
  }


}