import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/common/utils/error/err/sign_in_err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:dartz/dartz.dart';

extension EitherCatch on Either {
 
  static Future<Either<Err, R>> catchAsync<R, E extends Err>(
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
  static Either<Err, R> catchE<R, E extends Err>(
    R Function() block,  
    Err Function(Exception exception) errorBlock,  //
  ) {
    try {
      final result = block();  
      return Right(result);  
    } on Exception catch (e) {
 
      return Left(errorBlock(e));  
    }
 
  }
}
extension FutureEitherExtensions<L, R> on Future<EitherErr<R>> {
  Future<EitherErr<T>> flatMap<T>(
      Future<EitherErr<T>> Function(R value) f) async {
    final either = await this;
    return either.fold(
      (l) => Left(l),
      (r) async => await f(r),
    );
  }
}
