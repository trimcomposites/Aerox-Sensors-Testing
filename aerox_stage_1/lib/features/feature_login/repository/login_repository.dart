import 'package:aerox_stage_1/common/utils/error/err/sign_in_err.dart';
import 'package:aerox_stage_1/common/utils/error/err/status_code.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/aerox_user.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/apple_auth_service.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/firebase_user_extension.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'remote/remote_barrel.dart';

class LoginRepository{

  LoginRepository({ required this.firebaseAuth, required this.emailAuthService, required this.googleAuthService, required this.appleAuthService });
  final FirebaseAuth firebaseAuth;
  final EmailAuthService emailAuthService;
  final GoogleAuthService googleAuthService;
  final AppleAuthService appleAuthService;

  Future<EitherErr<AeroxUser>>signInUser( { required EmailSignInType signInType, AeroxUser? aeroxUser }) async{
    switch( signInType ){
      case EmailSignInType.email:
      return emailAuthService.signInWithEmail(aeroxUser: aeroxUser! );
      case EmailSignInType.google:
        return googleAuthService.signInWithGoogle();
      case EmailSignInType.apple:
        return appleAuthService.signInWithApple();
      case EmailSignInType.meta:
        // TODO: Handle this case.
        throw UnimplementedError();
    }


  }

  Future<EitherErr<void>> signOutUser( { required EmailSignInType signInType} ) async{
    switch( signInType ){
      case EmailSignInType.email:
      return emailAuthService.signOut();
      case EmailSignInType.google:
        return googleAuthService.signOut();
      case EmailSignInType.apple:
        appleAuthService.signOut();
        throw UnimplementedError();
      case EmailSignInType.meta:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  Future<EitherErr<AeroxUser>> registerWithEmail( AeroxUser aeroxUser ) async{
    final user = await emailAuthService.createUserWithEmail( aeroxUser: aeroxUser );
    return user;
  }

  Future<EitherErr<void>> resetPassword( { required String email} ) async{
    final result = emailAuthService.sendPasswordResetEmail(email: email);
    return result;
  }

  Future<EitherErr<AeroxUser>>checkUserSignedIn() async{
    final result = firebaseAuth.currentUser;
    if(result!=null) {
      return right(result.toAeroxUser());
    } else {
      return left(SignInErr(errMsg: 'no hay usuario loggeado', statusCode: StatusCode.networkError));
    }
  }


}