import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/use_cases/use_case.dart';
import 'package:aerox_stage_1/domain/user_data.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/login_repository.dart';

import 'package:firebase_auth/firebase_auth.dart';

class RegisterUserUsecase extends UseCaseWithParams<dynamic, UserData>{

  @override
  ResultFuture call( UserData userData  )async => await LoginRepository().registerWithEmail(userData);


}