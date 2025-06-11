
import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/domain/models/racket.dart';

class BlobErr extends Err{
  BlobErr( { 
    required super.errMsg, 
    required super.statusCode, 
  });

}