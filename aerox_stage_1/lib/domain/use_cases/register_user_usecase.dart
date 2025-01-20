import 'package:aerox_stage_1/domain/use_cases/use_case.dart';
import 'package:aerox_stage_1/domain/user_data.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/login_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterUserUsecase extends UseCase<dynamic, UserData>{

  RegisterUserUsecase({ required  this.userData });

  final UserData userData;
  
  @override
  call() async{
    final user  = await LoginRepository().registerWithEmail(userData);
    return user;
  }


}