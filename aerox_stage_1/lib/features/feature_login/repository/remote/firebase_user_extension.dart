import 'package:aerox_stage_1/domain/models/aerox_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

extension FirebaseUserExtensions on User {
  AeroxUser toAeroxUser({String? name }) {
    return AeroxUser(
      name: displayName ?? name ??'Unknown', // Usa displayName o un valor por defecto.
      email: email ?? 'No email',    // Usa el email o un valor por defecto.
      password: null,       
      id: uid         // Firebase no expone contraseñas por razones de seguridad.
    );
  }
}
