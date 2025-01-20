import 'package:aerox_stage_1/common/utils/sign_in_err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final GoogleAuthService _instance = GoogleAuthService._internal();

    // Constructor privado
    GoogleAuthService._internal();

    // Devuelve la instancia única
    factory GoogleAuthService() {
      return _instance;
    }

  // Método para iniciar sesión con Google
  static ResultFuture<User> signInWithGoogle() async {
    try {
      // Selecciona una cuenta de Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return left( SignInErr(  statusCode: 1, errMsg: 'dfdffd')  );

      // Obtiene las credenciales de autenticación de Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Crea una credencial de Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Inicia sesión en Firebase con las credenciales de Google
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Retorna el usuario autenticado
      return right( userCredential.user! );  
    } catch (e) {
      print('Error en signInWithGoogle: $e');
      return left( SignInErr(  statusCode: 1, errMsg: 'dfdffd')  );
    }
  }

  // Método para cerrar sesión
  static Future<void> signOut() async {
    try {
      await _googleSignIn.signOut(); // Cierra sesión de Google
      await _auth.signOut(); // Cierra sesión de Firebase
    } catch (e) {
      print('Error en signOut: $e');
    }
  }
}