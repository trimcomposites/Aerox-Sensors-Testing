import 'package:equatable/equatable.dart';

class Racket extends Equatable{
  final String name;
  final String img;
  final num length;
  final num weight;
  final String pattern;
  final num balance;
  

  Racket({
    required this.name,
    required this.length,
    required this.weight,
    required this.img,
    required this.pattern,
    required this.balance,

  });

  
  @override
  List<Object?> get props => [ name, length, weight, pattern, balance, img ];
}