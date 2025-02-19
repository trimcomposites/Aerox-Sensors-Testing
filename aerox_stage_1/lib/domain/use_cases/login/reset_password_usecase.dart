import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/use_cases/login/email_sign_in_type.dart';
import 'package:aerox_stage_1/domain/use_cases/use_case.dart';
import 'package:aerox_stage_1/features/feature_login/repository/login_repository.dart';

class ResetPasswordUseCase extends AsyncUseCaseWithParams<void, String>{

  const ResetPasswordUseCase({ required this.loginRepo  });

  final LoginRepository loginRepo;

  @override
  Future<EitherErr<void>> call( String params ) async {
    return loginRepo.resetPassword( email: params );
  } 

}
