
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/use_cases/email_sign_in_type.dart';
import 'package:aerox_stage_1/domain/use_cases/use_case.dart';
import 'package:aerox_stage_1/domain/user_data.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/login_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInUserUsecase extends UseCaseWithParams<User, SignInUserUsecaseParams>{


  @override
  ResultFuture<User> call( SignInUserUsecaseParams params ) async {
    var user = LoginRepository().signInUser( signInType: params.signInType, userData: params.userData );
    print( user );
    return user;
  } 

}
class SignInUserUsecaseParams extends Equatable {

  final EmailSignInType signInType;
  final UserData? userData;

  SignInUserUsecaseParams({required this.signInType, this.userData});

  @override
  List<Object?> get props => [ signInType, userData ];

}