import 'package:equatable/equatable.dart';

class Racket extends Equatable{
  final int id;
  final String name;
  final String img;
  final num length;
  final num weight;
  final String pattern;
  final num balance;
  

  const Racket({
    required this.id,
    required this.name,
    required this.length,
    required this.weight,
    required this.img,
    required this.pattern,
    required this.balance,

  });

  
  @override
  List<Object?> get props => [ name, length, weight, pattern, balance, img ];

    // Convertir un mapa de la base de datos a un objeto Racket
  factory Racket.fromMap(Map<String, dynamic> map) {
    return Racket(
      id: map['id'],
      name: map['name'],
      img: map['img'],
      length: map['length'],
      weight: map['weight'],
      pattern: map['pattern'],
      balance: map['balance'],
    );
  }

  // Convertir un objeto Racket a un mapa para la base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'img': img,
      'length': length,
      'weight': weight,
      'pattern': pattern,
      'balance': balance,
    };
  }
}
