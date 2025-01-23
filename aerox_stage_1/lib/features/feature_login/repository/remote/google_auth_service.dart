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

  GoogleAuthService({required this.auth, required this.googleSignIn}) ;



  // Método para iniciar sesión con Google
  Future<EitherErr<AeroxUser>> signInWithGoogle() async {
     return EitherCatchExtension.catchE<AeroxUser, SignInErr>(() async {
      // Selecciona una cuenta de Google
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Error al iniciar sesión con Google');
      }

      // Obtiene las credenciales de autenticación de Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Crea una credencial de Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Inicia sesión en Firebase con las credenciales de Google
      final UserCredential userCredential = await auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        return user.toAeroxUser();
      } else {
        throw Exception('Usuario no encontrado');
      }
    }, (message, statusCode) => SignInErr(errMsg: message, statusCode: statusCode));
  }


  // Método para cerrar sesión
  Future<EitherErr<void>> signOut() async {
    try {
      await googleSignIn.signOut(); // Cierra sesión de Google
      await auth.signOut(); // Cierra sesión de Firebase
      return right( (){} );
    } catch (e) {
      return left( SignInErr(  statusCode: StatusCode.googleSignInError, errMsg: e.toString() )  );
    }
  }
}