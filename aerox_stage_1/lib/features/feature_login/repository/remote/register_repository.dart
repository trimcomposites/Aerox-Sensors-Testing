
import 'package:aerox_stage_1/domain/models/aerox_user.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/email_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterRepository {

  final EmailAuthService emailAuthService;

  RegisterRepository({required this.emailAuthService});

  registerWithEmail( AeroxUser aeroxUser ) async{
    final user = await emailAuthService.createUserWithEmail( aeroxUser: aeroxUser );
    return user;
  }


}