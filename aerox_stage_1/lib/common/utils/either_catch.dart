import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/common/utils/error/err/sign_in_err.dart';
import 'package:dartz/dartz.dart';

extension EitherCatch on Either {
 
  static Future<Either<Err, R>> catchE<R, E extends Err>(
    Future<R> Function() block,  
    Err Function(Exception exception) errorBlock,  //
  ) async {
    try {
      final result = await block();  
      return Right(result);  
    } on Exception catch (e) {
 
      return Left(errorBlock(e));  
    }
 
  }
}
