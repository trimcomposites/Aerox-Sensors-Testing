import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/domain/models/comment.dart';


class CommentErr extends Err{
  final Comment? racket;
  CommentErr( { 
    this.racket,
    required super.errMsg, 
    required super.statusCode, 
  });

}