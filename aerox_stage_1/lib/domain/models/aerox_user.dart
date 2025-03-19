import 'package:equatable/equatable.dart';

class AeroxUser  extends Equatable{
  final String name;
  final String id;
  final String email;
  final String? password;

  AeroxUser({
    required this.name,
    required this.id,
    required this.email,
    this.password,
  });

  AeroxUser copyWith({
    String? name,
    String? id,
    String? email,
    String? password,
  }) {
    return AeroxUser(
      name: name ?? this.name,
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
  
  @override
  List<Object?> get props => [ name, id, email, password ];
}
