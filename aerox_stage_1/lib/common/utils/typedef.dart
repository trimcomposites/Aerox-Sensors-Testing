import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:dartz/dartz.dart';
 
typedef EitherErr<T> = Either<Err, T>;
