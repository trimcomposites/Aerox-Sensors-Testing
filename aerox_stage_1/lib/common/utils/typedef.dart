import 'package:aerox_stage_1/common/utils/err.dart';
import 'package:dartz/dartz.dart';
 
typedef ResultFuture<T> = Future<Either<Err, T>>;
