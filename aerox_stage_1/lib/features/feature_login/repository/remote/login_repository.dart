import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/aerox_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'remote_barrel.dart';

class LoginRepository{

  LoginRepository({ required this.firebaseAuth, required this.emailAuthService, required this.googleAuthService });
  final FirebaseAuth firebaseAuth;
  final EmailAuthService emailAuthService;
  final GoogleAuthService googleAuthService;

  Future<EitherErr<AeroxUser>>signInUser( { required EmailSignInType signInType, AeroxUser? aeroxUser }) async{
    switch( signInType ){
      case EmailSignInType.email:
      return emailAuthService.signInWithEmail(aeroxUser: aeroxUser! );
      case EmailSignInType.google:
        return googleAuthService.signInWithGoogle();
      case EmailSignInType.apple:
        // TODO: Handle this case.
        throw UnimplementedError();
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
        throw UnimplementedError();
      case EmailSignInType.apple:
        // TODO: Handle this case.
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



}