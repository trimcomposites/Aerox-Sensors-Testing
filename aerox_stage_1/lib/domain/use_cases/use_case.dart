import 'package:aerox_stage_1/common/utils/typedef.dart';

abstract class UseCaseWithParams<Type, Params> {

  const UseCaseWithParams();
  ResultFuture<Type> call( Params params );
}
abstract class UseCaseWithoutParams<Type, Params> {

  const UseCaseWithoutParams();
  ResultFuture<Type> call();
}

