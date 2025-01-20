import 'package:aerox_stage_1/common/utils/sign_in_err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/user_data.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_auth/firebase_auth.dart';

class EmailAuthService {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  static Future<EitherErr<User>> signInWithEmail({
    required UserData userData
  }) async {
    try {
      UserCredential credential = await firebaseAuth.signInWithEmailAndPassword(
        email: userData.email,
        password: userData.password,
      );
      User? user = credential.user;

      if (user != null) return right( user );

      return left(SignInErr( errMsg: 'Ocurrió un error desconocido. Por favor, inténtelo nuevamente.', statusCode: 2 ));
    } on FirebaseAuthException catch (e) {
      return left( _handleSignInError(e) );
    } catch (error) {
      return left(SignInErr( errMsg: error.toString(), statusCode: 2 ));
    }
  }

  static Future<dynamic> createUserWithEmail({
    required UserData userData
  }) async {
    try {
      UserCredential credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: userData.email,
        password: userData.password,
      );
      User? user = credential.user;

      if (user != null) return user;

      return 'Ocurrió un error desconocido. Por favor, inténtelo nuevamente.';
    } on FirebaseAuthException catch (e) {
      return _handleSignUpError(e);
    } catch (error) {
      return 'Error inesperado: $error';
    }
  }

  static Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  static SignInErr _handleSignInError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return SignInErr( errMsg: 'No se encontró un usuario con ese correo. Verifique e intente nuevamente.', statusCode: 2 );
      case 'wrong-password':
      return SignInErr( errMsg: 'La contraseña es incorrecta. Por favor, intente nuevamente.', statusCode: 2 );
      case 'invalid-email':
        return SignInErr( errMsg: 'El formato del correo es inválido. Verifique el correo ingresado.', statusCode: 2 );
      case 'user-disabled':
        return SignInErr( errMsg: 'La cuenta ha sido deshabilitada. Contacte al soporte.', statusCode: 2 );
      default:
        return SignInErr( errMsg: e.message!, statusCode: 2 );
    }
  }

  static String _handleSignUpError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'El correo ya está en uso. Intente con otro correo.';
      case 'weak-password':
        return 'La contraseña es demasiado débil. Intente con una más segura.';
      case 'invalid-email':
        return 'El formato del correo es inválido. Verifique el correo ingresado.';
      default:
        return 'Error desconocido: ${e.message}';
    }
  }
}






