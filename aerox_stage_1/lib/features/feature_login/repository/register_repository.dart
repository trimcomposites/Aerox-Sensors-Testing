
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/aerox_user.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/email_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterRepository {

  final EmailAuthService emailAuthService;

  RegisterRepository({required this.emailAuthService});

  Future<EitherErr<AeroxUser>> registerWithEmail(AeroxUser aeroxUser) async {
    final result = await emailAuthService.createUserWithEmail(aeroxUser: aeroxUser);
    return result;
  }
}