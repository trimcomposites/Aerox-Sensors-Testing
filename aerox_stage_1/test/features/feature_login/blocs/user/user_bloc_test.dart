import 'package:aerox_stage_1/domain/use_cases/login/register_user_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/sign_in_user_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/sign_out_user_usecase.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mock_types.dart';

void main(){

  late UserBloc userBloc;
  late SignInUserUsecase signInUserUsecase;
  late SignOutUserUsecase signOutUserUsecase;
  late RegisterUserUsecase registerUserUsecase;
  setUp((){
    signInUserUsecase = MockSignInUserUseCase();
    signOutUserUsecase = MockSignOutUserUsecase();
    registerUserUsecase = MockRegisterUserUsecase();
    //userBloc = UserBloc(  , loginRepository)
  });

  test( 'event de sign in email', (){

  });
}