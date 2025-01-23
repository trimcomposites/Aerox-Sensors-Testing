import 'package:aerox_stage_1/common/utils/error/err/sign_in_err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/aerox_user.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_auth/firebase_auth.dart';

class EmailAuthService {
  final FirebaseAuth firebaseAuth;

  EmailAuthService({required this.firebaseAuth});

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<EitherErr<AeroxUser>> signInWithEmail({
    required AeroxUser aeroxUser
  }) async {
    try {
      UserCredential credential = await firebaseAuth.signInWithEmailAndPassword(
        email: aeroxUser.email,
        password: aeroxUser.password!,
      );
      User? user = credential.user;

      if (user != null) return right( AeroxUser.fromFirebaseUser(user) );

      return left(SignInErr( errMsg: 'Ocurrió un error desconocido. Por favor, inténtelo nuevamente.', statusCode: 2 ));
    } on FirebaseAuthException catch (e) {
      return left( _handleSignInError(e) );
    } catch (error) {
      return left(SignInErr( errMsg: error.toString(), statusCode: 2 ));
    }
  }

  Future<EitherErr<AeroxUser>> createUserWithEmail({
    required AeroxUser aeroxUser
  }) async {
    try {
      UserCredential credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: aeroxUser.email,
        password: aeroxUser.password!,
      );
      User? user = credential.user;

      if (user != null) return right( AeroxUser.fromFirebaseUser(user) );

      return left(SignInErr( errMsg: 'Ocurrió un error desconocido. Por favor, inténtelo nuevamente.', statusCode: 2 ));
    } on FirebaseAuthException catch (e) {
      return left(_handleSignUpError(e));
    } catch (error) {
      return left(SignInErr( errMsg: 'Ocurrió un error desconocido. $error', statusCode: 2 ));
    }
  }

  Future<EitherErr<void>> signOut() async {
    try{
      return right(firebaseAuth.signOut() ) ;
    }catch( e ){
      return left(SignInErr( errMsg: e.toString() , statusCode: 2 ));
    }
   
  }
  Future<EitherErr<void>> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      // Envía el correo para restablecer la contraseña
      await firebaseAuth.sendPasswordResetEmail(email: email);

      // Si es exitoso, retorna un resultado positivo
      return right(null);
    } on FirebaseAuthException catch (e) {
      // Maneja errores específicos de Firebase
      return left(_handlePasswordResetError(e));
    } catch (error) {
      // Maneja cualquier otro error
      return left(SignInErr(
        errMsg: 'Ocurrió un error al enviar el correo de restablecimiento. $error',
        statusCode: 2,
      ));
    }
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

  static SignInErr _handleSignUpError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
      return SignInErr( errMsg: 'El correo ya está en uso. Intente con otro correo.', statusCode: 2 );
      case 'weak-password':
      return SignInErr( errMsg: 'La contraseña es demasiado débil. Intente con una más segura.', statusCode: 2 );
      case 'invalid-email':
      return SignInErr( errMsg: 'El formato del correo es inválido. Verifique el correo ingresado.', statusCode: 2 );
      default:
      return SignInErr( errMsg: 'Error desconocido: ${e.message}', statusCode: 2 );
    }
  }
}

SignInErr _handlePasswordResetError(FirebaseAuthException e) {
  switch (e.code) {
    case 'invalid-email':
      return SignInErr(
        errMsg: 'El correo electrónico proporcionado no es válido. Por favor, verifíquelo e intente nuevamente.',
        statusCode: 3,
      );
    case 'user-not-found':
      return SignInErr(
        errMsg: 'No existe una cuenta con este correo electrónico. Por favor, verifique e intente nuevamente.',
        statusCode: 4,
      );
    default:
      return SignInErr(
        errMsg: 'Error desconocido al enviar el correo: ${e.message}',
        statusCode: 2,
      );
  }
}




