
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/aerox_user.dart';
import 'package:aerox_stage_1/domain/use_cases/login/email_sign_in_type.dart';
import 'package:aerox_stage_1/domain/use_cases/use_case.dart';
import 'package:aerox_stage_1/features/feature_login/repository/login_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInUserUsecase extends AsyncUseCaseWithParams<AeroxUser, SignInUserUsecaseParams>{

  const SignInUserUsecase({ required this.loginRepo });

  final LoginRepository loginRepo;

  @override
  Future<EitherErr<AeroxUser>>call( SignInUserUsecaseParams params ) async {
    final user = loginRepo.signInUser( signInType: params.signInType, aeroxUser: params.user );
    return user;

  } 

}
class SignInUserUsecaseParams extends Equatable {

  final EmailSignInType signInType;
  final AeroxUser? user;

  const SignInUserUsecaseParams({required this.signInType, this.user});

  SignInUserUsecaseParams.empty()
      : signInType = EmailSignInType.email,
        user = AeroxUser(name: 'name', email: 'email', password: 'password');

  @override
  List<Object?> get props => [ signInType, user ];

}