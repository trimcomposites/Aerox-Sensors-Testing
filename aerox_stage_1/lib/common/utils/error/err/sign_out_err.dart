import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/common/utils/exceptions/sign_in_exception.dart';

class SignOutErr extends Err{
  SignOutErr({required super.errMsg, required super.statusCode, });
    factory SignOutErr.fromException( SignInException ex ) => SignOutErr( errMsg: ex.message, statusCode: ex.statusCode );
}