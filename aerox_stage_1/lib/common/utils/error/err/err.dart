import 'package:aerox_stage_1/common/utils/exceptions/exception.dart';
import 'package:equatable/equatable.dart';

abstract class Err extends Equatable{


  final String errMsg;
  final int statusCode;

  Err({required this.errMsg, required this.statusCode});


  @override

  List<Object?> get props => [ this.errMsg, this.statusCode ];
}