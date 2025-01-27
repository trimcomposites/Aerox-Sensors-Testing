import 'package:equatable/equatable.dart';

abstract class MyException extends Equatable implements Exception{

  const MyException({ required this.message, required this.statusCode });

  final String message;
  final int statusCode;
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

}