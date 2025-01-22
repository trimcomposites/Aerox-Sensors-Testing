import 'package:aerox_stage_1/common/utils/error/err/sign_in_err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/aerox_user.dart';
import 'package:aerox_stage_1/domain/use_cases/use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckUserSignedInUsecase extends UseCaseWithoutParams<AeroxUser>{

  final FirebaseAuth firebaseAuth;
  const CheckUserSignedInUsecase({ required this.firebaseAuth });
  @override
  EitherErr<AeroxUser> call() {
    User? user = firebaseAuth.currentUser;
    if(user!=null){
      return right(AeroxUser.fromFirebaseUser(user));
    }else{
      return left(SignInErr(errMsg: 'no hay usuario con sesion iniciada', statusCode: 6));
    }
  }
}