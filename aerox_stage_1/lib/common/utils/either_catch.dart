import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/common/utils/error/err/sign_in_err.dart';
import 'package:dartz/dartz.dart';

extension EitherCatchExtension on Either {

  static Future<Either<Err, R>> catchE<R, E extends Err>(
    Future<R> Function() block,  
    E Function(String message, int statusCode) errorMapper,  //
  ) async {
    try {
      final result = await block();  
      return Right(result);  
    } catch (exception) {

      return Left(errorMapper(exception.toString(), exception.hashCode));  
    }
  }
}