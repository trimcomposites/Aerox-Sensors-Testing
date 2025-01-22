import 'package:firebase_auth/firebase_auth.dart';

class AeroxUser {

  final String name;
  final String email;

  AeroxUser({required this.name, required this.email});

  factory AeroxUser.fromFirebaseUser( User user ) => AeroxUser(name: user.displayName ?? emailToName(user.email!), email: user.email! );

  static String emailToName(String email) {
  // Elimina la parte del dominio
  String localPart = email.split('@').first;

  // Divide por puntos (.) o guiones bajos (_)
  List<String> parts = localPart.split(RegExp(r'[._]'));

  // Filtra los elementos que contengan números y están vacíos
  parts = parts.where((part) => !RegExp(r'\d').hasMatch(part) && part.isNotEmpty).toList();

  // Convierte cada palabra a Capitalize (Primera letra mayúscula)
  List<String> capitalizedParts = parts.map((part) {
    return part[0].toUpperCase() + part.substring(1).toLowerCase();
  }).toList();

  // Une las partes con espacio para formar el nombre completo
  return capitalizedParts.join(' ');
  }

}