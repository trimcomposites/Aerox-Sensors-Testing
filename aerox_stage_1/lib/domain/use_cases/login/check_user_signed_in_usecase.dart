import 'package:aerox_stage_1/common/utils/error/err/sign_in_err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/aerox_user.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/firebase_user_extension.dart';
import 'package:aerox_stage_1/domain/use_cases/use_case.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/login_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckUserSignedInUsecase extends AsyncUseCaseWitoutParams<AeroxUser>{

  final LoginRepository loginRepo;
  const CheckUserSignedInUsecase({ required this.loginRepo });
  @override
  Future<EitherErr<AeroxUser>> call() async{
    return loginRepo.checkUserSignedIn();
  }
}