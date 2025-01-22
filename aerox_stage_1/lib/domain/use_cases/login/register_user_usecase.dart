import 'package:aerox_stage_1/common/utils/error/err/sign_in_err.dart';
import 'package:aerox_stage_1/common/utils/exceptions/sign_in_exception.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/aerox_user.dart';
import 'package:aerox_stage_1/domain/use_cases/use_case.dart';
import 'package:aerox_stage_1/domain/user_data.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/login_repository.dart';
import 'package:dartz/dartz.dart';

import 'package:firebase_auth/firebase_auth.dart';

class RegisterUserUsecase extends AsyncUseCaseWithParams<dynamic, UserData>{

  const RegisterUserUsecase({ required this.loginRepo  });

  final LoginRepository loginRepo;

  @override
  Future<EitherErr<AeroxUser>> call( UserData userData  )async {
    
    final user = await loginRepo.registerWithEmail(userData);
    return user;

  } 


}