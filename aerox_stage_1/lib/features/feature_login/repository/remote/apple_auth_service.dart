import 'package:aerox_stage_1/common/utils/either_catch.dart';
import 'package:aerox_stage_1/common/utils/error/err/sign_in_err.dart';
import 'package:aerox_stage_1/common/utils/error/err/status_code.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/aerox_user.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/firebase_user_extension.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleAuthService {
  final FirebaseAuth auth;

  AppleAuthService({required this.auth});



  Future<EitherErr<AeroxUser>> signInWithApple() async {
    return EitherCatch.catchAsync<AeroxUser, SignInErr>(() async {
      // Crear el proveedor de Apple con permisos de email y nombre
      final appleProvider = AppleAuthProvider()
        ..addScope('email')
        ..addScope('name');

      // Iniciar sesión con Apple a través de Firebase
      final UserCredential userCredential = await auth.signInWithProvider(appleProvider);
      final User? user = userCredential.user;

      if (user != null) {
        // Extraer información adicional del usuario
        final additionalInfo = userCredential.additionalUserInfo;
        final profile = additionalInfo?.profile;


        // Convertir a AeroxUser con el nombre correcto
        final aeroxUser = user.toAeroxUser();
        return aeroxUser;
      } else {
        throw Exception('Usuario no encontrado después de iniciar sesión con Apple.');
      }
    }, (exception) => SignInErr(errMsg: exception.toString(), statusCode: 12));
  }


  Future<EitherErr<void>> signOut() async {
    return EitherCatch.catchAsync<void, SignInErr>(() async {
      await auth.signOut();
      return null;
    }, (exception) => SignInErr(errMsg: exception.toString(), statusCode: 12));
  }
}
