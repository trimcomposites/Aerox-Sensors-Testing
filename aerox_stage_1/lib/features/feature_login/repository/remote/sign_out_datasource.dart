import 'remote_barrel.dart';

class SignOutDatasource {
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