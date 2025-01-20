import 'remote_barrel.dart';

class SignInDatasource{
  signInUser( { required EmailSignInType signInType, UserData? userData }) async{
    switch( signInType ){
      case EmailSignInType.email:
      return await EmailAuthService.signInWithEmail(userData: userData! );
      case EmailSignInType.google:
        return await GoogleAuthService.signInWithGoogle();
        throw UnimplementedError();
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
}