import 'package:aerox_stage_1/common/utils/typedef.dart';

abstract class UseCaseWithParams<Type, Params> {

  const UseCaseWithParams();
  EitherErr<Type> call( Params params );
}
abstract class AsyncUseCaseWithParams<Type, Params> {

  const AsyncUseCaseWithParams();
  Future<EitherErr<Type>> call( Params params );
}
abstract class UseCaseWithoutParams<Type, Params> {

  const UseCaseWithoutParams();
  EitherErr<Type> call();
}

