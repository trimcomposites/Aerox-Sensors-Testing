import 'package:aerox_stage_1/common/utils/typedef.dart';

abstract class UseCaseWithParams<Type, Params> {

  const UseCaseWithParams();
  EitherErr<Type> call( Params params );
}
abstract class AsyncUseCaseWithParams<Type, Params> {

  const AsyncUseCaseWithParams();
  Future<EitherErr<Type>> call( Params params );
}
abstract class AsyncUseCaseWithoutParams<Type> {

  const AsyncUseCaseWithoutParams();
  Future<EitherErr<Type>> call();
}
abstract class UseCaseWithoutParams<Type> {

  const UseCaseWithoutParams();
  EitherErr<Type> call();
}

