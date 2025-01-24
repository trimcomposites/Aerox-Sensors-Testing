import 'package:aerox_stage_1/common/utils/either_catch.dart';
import 'package:aerox_stage_1/common/utils/error/err/sign_in_err.dart';
import 'package:aerox_stage_1/common/utils/error/err/status_code.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/aerox_user.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/firebase_user_extension.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {

  final FirebaseAuth auth;
  final GoogleSignIn googleSignIn;

  GoogleAuthService({required this.auth, required this.googleSignIn});
  
Future<EitherErr<AeroxUser>> signInWithGoogle() async {
  return EitherCatch.catchAsync<AeroxUser, SignInErr>(() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Error al iniciar sesión con Google');
    }

    final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
    if (googleAuth == null) {
      throw Exception('Error al obtener las credenciales de Google');
    }

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential = await auth.signInWithCredential(credential);
    final User? user = userCredential.user;

    if (user != null) {
      return user.toAeroxUser();
    } else {
      throw Exception('Usuario no encontrado');
    }
  }, (exception) => SignInErr(errMsg: exception.toString(), statusCode: StatusCode.googleSignInError));
}

  Future<EitherErr<void>> signOut() async {
    return EitherCatch.catchAsync<void, SignInErr>(() async {
      await googleSignIn.signOut();
      await auth.signOut();
      return null;
    }, (exception) => SignInErr(errMsg: exception.toString(), statusCode: StatusCode.googleSignInError));
  }
}