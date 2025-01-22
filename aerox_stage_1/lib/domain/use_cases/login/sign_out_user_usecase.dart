import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/use_cases/use_case.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/login_repository.dart';

import 'email_sign_in_type.dart';

class SignOutUserUsecase extends AsyncUseCaseWithParams<void, EmailSignInType>{

  const SignOutUserUsecase({ required this.loginRepo  });

  final LoginRepository loginRepo;

  @override
    @override
  Future<EitherErr<void>> call( EmailSignInType params ) async {
    return loginRepo.signOutUser( signInType: params );

  } 
  

}
