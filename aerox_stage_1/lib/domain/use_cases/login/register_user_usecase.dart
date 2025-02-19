import 'package:aerox_stage_1/common/utils/error/err/sign_in_err.dart';
import 'package:aerox_stage_1/common/utils/exceptions/sign_in_exception.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/aerox_user.dart';
import 'package:aerox_stage_1/domain/use_cases/use_case.dart';
import 'package:aerox_stage_1/features/feature_login/repository/login_repository.dart';
import 'package:dartz/dartz.dart';

import 'package:firebase_auth/firebase_auth.dart';

class RegisterUserUsecase extends AsyncUseCaseWithParams<dynamic, AeroxUser>{

  const RegisterUserUsecase({ required this.loginRepo  });

  final LoginRepository loginRepo;

  @override
  Future<EitherErr<AeroxUser>> call( AeroxUser params  )async {
    
    final user = await loginRepo.registerWithEmail(params);
    return user;

  } 


}