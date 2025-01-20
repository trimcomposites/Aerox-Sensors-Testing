import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'remote_barrel.dart';

class LoginRepository{
  ResultFuture<User> signInUser( { required EmailSignInType signInType, UserData? userData }) async{
    switch( signInType ){
      case EmailSignInType.email:
      //return EmailAuthService.signInWithEmail(userData: userData! );
      case EmailSignInType.google:
        return GoogleAuthService.signInWithGoogle();
      case EmailSignInType.apple:
        // TODO: Handle this case.
        throw UnimplementedError();
      case EmailSignInType.meta:
        // TODO: Handle this case.
        throw UnimplementedError();
    }


  }

  signOutUser( { required EmailSignInType signInType} ) async{
    switch( signInType ){
      case EmailSignInType.email:
      return await EmailAuthService.signOut();
      case EmailSignInType.google:
        return await GoogleAuthService.signOut();
        throw UnimplementedError();
      case EmailSignInType.apple:
        // TODO: Handle this case.
        throw UnimplementedError();
      case EmailSignInType.meta:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  registerWithEmail( UserData userData ) async{
    final user = await EmailAuthService.createUserWithEmail( userData: userData );
    return user;
  }



}