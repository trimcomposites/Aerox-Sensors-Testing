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

  Future<EitherErr<AeroxUser>> signInWithEmail({
    required AeroxUser aeroxUser,
  }) async {
    return EitherCatch.catchAsync<AeroxUser, SignInErr>(() async {
      UserCredential credential = await firebaseAuth.signInWithEmailAndPassword(
        email: aeroxUser.email,
        password: aeroxUser.password!,
      );
      User? user = credential.user;

      if (user != null) {
        await user.updateDisplayName( aeroxUser.name );
        return user.toAeroxUser(); 
      } else {
        throw Exception('Ocurrió un error desconocido. Por favor, inténtelo nuevamente.');
      }
    }, (exception) => SignInErr(errMsg: _handleSignInError(exception), statusCode: StatusCode.authenticationFailed));
  }
Future<EitherErr<AeroxUser>> createUserWithEmail({
  required AeroxUser aeroxUser,
}) async {
  return EitherCatch.catchAsync<AeroxUser, SignInErr>(() async {
    UserCredential credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: aeroxUser.email,
      password: aeroxUser.password!,
    
    );

    User? user = credential.user;

    if (user != null) {
      await user.updateDisplayName( aeroxUser.name );
      return user.toAeroxUser(); 
    } else {
      throw Exception('Ocurrió un error desconocido. Por favor, inténtelo nuevamente.');
    }
  }, (exception) => SignInErr(errMsg: _handleSignUpError(exception), statusCode: StatusCode.registrationFailed));
}
Future<EitherErr<void>> signOut() async {
  return EitherCatch.catchAsync<void, SignInErr>(() async {
    await firebaseAuth.signOut();  
  }, (exception) => SignInErr(errMsg: exception.toString(), statusCode: StatusCode.authenticationFailed));
}

Future<EitherErr<void>> sendPasswordResetEmail({
  required String email,
}) async {
  return EitherCatch.catchAsync<void, SignInErr>(() async {

    await firebaseAuth.sendPasswordResetEmail(email: email);
  }, (exception) => SignInErr(
    errMsg: exception.toString(),
    statusCode: StatusCode.authenticationFailed,
  ));
}
String _handleSignInError(Exception e) {
  String errMsg = '';

  if (e is FirebaseAuthException) {
    switch (e.code) {
      case 'user-not-found':
        errMsg = 'No se encontró un usuario con ese correo. Verifique e intente nuevamente.';
        break;
      case 'wrong-password':
        errMsg = 'La contraseña es incorrecta. Por favor, intente nuevamente.';
        break;
      case 'invalid-email':
        errMsg = 'El formato del correo es inválido. Verifique el correo ingresado.';
        break;
      case 'user-disabled':
        errMsg = 'La cuenta ha sido deshabilitada. Contacte al soporte.';
        break;
      default:
        errMsg = 'Error desconocido';
    }
  } else {
    errMsg = 'Ocurrió un error desconocido: ${e.toString()}';
  }
  return errMsg;
}
 String _handleSignUpError(Exception e) {
  String errMsg = '';

  if (e is FirebaseAuthException) {
    switch (e.code) {
      case 'email-already-in-use':
        errMsg = 'El correo ya está en uso. Intente con otro correo.';
        break;
      case 'weak-password':
        errMsg = 'La contraseña es demasiado débil. Intente con una más segura.';
        break;
      case 'invalid-email':
        errMsg = 'El formato del correo es inválido. Verifique el correo ingresado.';
        break;
      default:
        errMsg = 'Error desconocido';
    }
  } else {
    errMsg = 'Ocurrió un error desconocido: ${e.toString()}';
  }

  return errMsg;
}

  String _handlePasswordResetError(Exception e) {
    String errMsg = '';

    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          errMsg = 'No existe una cuenta con este correo electrónico. Por favor, verifique e intente nuevamente.';
          break;
        case 'invalid-email':
          errMsg = 'El formato del correo es inválido. Verifique el correo ingresado.';
          break;
        default:
          errMsg = 'Error desconocido';
      }
    } else {
      errMsg = 'Ocurrió un error desconocido: ${e.toString()}';
    }

    return errMsg;
}
}




