import 'package:aerox_stage_1/domain/user_data.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/register_datasource.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterUserUsecase {

  registerUser({ required UserData userData }){
    final user = RegisterDatasource().registerWithEmail(userData);
    return user;
  }


}