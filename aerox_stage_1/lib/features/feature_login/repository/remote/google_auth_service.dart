import 'package:aerox_stage_1/common/utils/error/err/sign_in_err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final FirebaseAuth auth;
  final GoogleSignIn googleSignIn;

  GoogleAuthService({required this.auth, required this.googleSignIn}) ;



  // Método para iniciar sesión con Google
  Future<EitherErr<User>> signInWithGoogle() async {
    try {
      // Selecciona una cuenta de Google
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return left( SignInErr(  statusCode: 1, errMsg: 'Error al iniciar sesión con goole')  );

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
      // Retorna el usuario autenticado
      if(user!=null) {
        return right( user  );
      } else {
        return left( SignInErr(errMsg: 'error, usuario no encontrado', statusCode: 3) );
      }
    } catch (e) {
      print('Error en signInWithGoogle: $e');
      return left( SignInErr(  statusCode: 1, errMsg: e.toString() )  );
    }
  }

  // Método para cerrar sesión
  Future<EitherErr<void>> signOut() async {
    try {
      await googleSignIn.signOut(); // Cierra sesión de Google
      await auth.signOut(); // Cierra sesión de Firebase
      return right( (){} );
    } catch (e) {
      return left( SignInErr(  statusCode: 1, errMsg: e.toString() )  );
    }
  }
}