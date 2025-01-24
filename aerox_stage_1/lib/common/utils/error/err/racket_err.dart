
import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/domain/models/racket.dart';

class RacketErr extends Err{
  final Racket? racket;
  RacketErr( { 
    this.racket,
    required super.errMsg, 
    required super.statusCode, 
  });

}