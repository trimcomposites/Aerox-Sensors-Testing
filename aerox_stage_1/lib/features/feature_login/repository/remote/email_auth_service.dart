import 'package:aerox_stage_1/common/utils/either_catch.dart';
import 'package:aerox_stage_1/common/utils/error/err/sign_in_err.dart';
import 'package:aerox_stage_1/common/utils/error/err/status_code.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/aerox_user.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/firebase_user_extension.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_auth/firebase_auth.dart';

class EmailAuthService {
  final FirebaseAuth firebaseAuth;

  EmailAuthService({required this.firebaseAuth});

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<EitherErr<AeroxUser>> signInWithEmail({
    required AeroxUser aeroxUser,
  }) async {
    return EitherCatchExtension.catchE<AeroxUser, SignInErr>(() async {
      // Intento de inicio de sesión con el correo y la contraseña
      UserCredential credential = await firebaseAuth.signInWithEmailAndPassword(
        email: aeroxUser.email,
        password: aeroxUser.password!,
      );

      // Obtenemos el usuario de la credencial
      User? user = credential.user;

      // Verificamos si el usuario existe
      if (user != null) {
        return user.toAeroxUser();
      } else {
        // Si no hay usuario, lanzamos un error
        throw Exception('Ocurrió un error desconocido. Por favor, inténtelo nuevamente.');
      }
    }, (message, statusCode) => SignInErr(errMsg: message, statusCode: statusCode));
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

      if (user != null) return right( user.toAeroxUser() );

      return left(SignInErr( errMsg: 'Ocurrió un error desconocido. Por favor, inténtelo nuevamente.', statusCode: StatusCode.registrationFailed ));
    } on FirebaseAuthException catch (e) {
      return left(_handleSignUpError(e));
    } catch (error) {
      return left(SignInErr( errMsg: 'Ocurrió un error desconocido. $error', statusCode: StatusCode.registrationFailed ));
    }
  }

  Future<EitherErr<void>> signOut() async {
    try{
      return right(firebaseAuth.signOut() ) ;
    }catch( e ){
      return left(SignInErr( errMsg: e.toString() , statusCode: StatusCode.authenticationFailed ));
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
        statusCode: StatusCode.authenticationFailed,
      ));
    }
  }

  static SignInErr _handleSignInError(FirebaseAuthException e) {
    String errMsg ='';

    switch (e.code) {
      case 'user-not-found':
        errMsg = 'No se encontró un usuario con ese correo. Verifique e intente nuevamente.';
      case 'wrong-password':
        errMsg = 'La contraseña es incorrecta. Por favor, intente nuevamente.';
      case 'invalid-email':
         errMsg = 'El formato del correo es inválido. Verifique el correo ingresado.';
      case 'user-disabled':
        errMsg = 'La cuenta ha sido deshabilitada. Contacte al soporte.';
      default:
      errMsg = 'Error desconocido';
    }
    return SignInErr( errMsg: errMsg, statusCode: StatusCode.authenticationFailed );
  }
  static SignInErr _handleSignUpError(FirebaseAuthException e) {
    String errMsg ='';

    switch (e.code) {
      case 'email-already-in-use':
        errMsg = 'El correo ya está en uso. Intente con otro correo.';
      case 'weak-password':
        errMsg = 'La contraseña es demasiado débil. Intente con una más segura.';
      case 'invalid-email':
         errMsg = 'El formato del correo es inválido. Verifique el correo ingresado.';
      default:
      errMsg = 'Error desconocido';
    }
    return SignInErr( errMsg: errMsg, statusCode: StatusCode.registrationFailed );
  }


  static SignInErr _handlePasswordResetError(FirebaseAuthException e) {
    String errMsg ='';

    switch (e.code) {
      case 'user-not-found':
        errMsg = 'No existe una cuenta con este correo electrónico. Por favor, verifique e intente nuevamente.';
      case 'invalid-email':
         errMsg = 'El formato del correo es inválido. Verifique el correo ingresado.';
      default:
      errMsg = 'Error desconocido';
    }
    return SignInErr( errMsg: errMsg, statusCode: StatusCode.passwordResetFailed );
  }
}






