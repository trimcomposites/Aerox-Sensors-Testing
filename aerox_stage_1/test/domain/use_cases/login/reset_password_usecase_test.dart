import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/common/utils/error/err/sign_in_err.dart';
import 'package:aerox_stage_1/domain/use_cases/login/reset_password_usecase.dart';
import 'package:aerox_stage_1/features/feature_login/repository/login_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mock_types.dart';

late LoginRepository loginRepository;
late ResetPasswordUsecase resetPasswordUsecase;
final String email = 'roberto@gmail.com';
void main() {

  setUp((){
    loginRepository = MockLoginRepo();
    resetPasswordUsecase = ResetPasswordUsecase(loginRepo: loginRepository);
  });
  group('reset password usecase ...', (){
    test('email sent success, must return [ void ]', () async {
      when(() => loginRepository.resetPassword(
        email: email

      )).thenAnswer((_) async => Right( null ));
      final result = await resetPasswordUsecase( email );

      expect(result, isA<Right<Err , void>>());
    });
    test('email sent failure, must return [ Err ]', () async {
      when(() => loginRepository.resetPassword(
        email: email

      )).thenAnswer((_) async => Left( SignInErr(errMsg: '',statusCode: 1) ));
      final result = await resetPasswordUsecase( email );

      expect(result, isA<Left<Err , void>>());
    });
  });
}