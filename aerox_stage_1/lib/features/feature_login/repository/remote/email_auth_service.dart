import 'package:aerox_stage_1/domain/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_auth/firebase_auth.dart';

class EmailAuthService {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  static Future<dynamic> signInWithEmail({
    required UserData userData
  }) async {
    try {
      UserCredential credential = await firebaseAuth.signInWithEmailAndPassword(
        email: userData.email,
        password: userData.password,
      );
      User? user = credential.user;

      if (user != null) return user;

      return 'Ocurrió un error desconocido. Por favor, inténtelo nuevamente.';
    } on FirebaseAuthException catch (e) {
      return _handleSignInError(e);
    } catch (error) {
      return 'Error inesperado: $error';
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

  static String _handleSignInError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No se encontró un usuario con ese correo. Verifique e intente nuevamente.';
      case 'wrong-password':
        return 'La contraseña es incorrecta. Por favor, intente nuevamente.';
      case 'invalid-email':
        return 'El formato del correo es inválido. Verifique el correo ingresado.';
      case 'user-disabled':
        return 'La cuenta ha sido deshabilitada. Contacte al soporte.';
      default:
        return 'Error desconocido: ${e.message}';
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






