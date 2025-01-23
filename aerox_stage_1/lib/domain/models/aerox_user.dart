import 'package:firebase_auth/firebase_auth.dart';

class AeroxUser {

  final String name;
  final String email;
  final String? password;

  AeroxUser({required this.name, required this.email, this.password});


}