import 'remote_barrel.dart';

class SignOutDatasource {

  final EmailAuthService emailAuthService;
  final GoogleAuthService googleAuthService;

  SignOutDatasource({required this.emailAuthService, required this.googleAuthService});
  

  signOutUser( { required EmailSignInType signInType} ) async{
    switch( signInType ){
      case EmailSignInType.email:
      return await emailAuthService.signOut();
      case EmailSignInType.google:
        return await googleAuthService.signOut();
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