import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/common/utils/exceptions/sign_in_exception.dart';

class SignInErr extends Err{
  SignInErr({required super.errMsg, required super.statusCode, });
    factory SignInErr.fromException( SignInException ex ) => SignInErr( errMsg: ex.message, statusCode: ex.statusCode );
}