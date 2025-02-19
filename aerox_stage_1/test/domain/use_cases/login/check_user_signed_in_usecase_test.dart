import 'package:aerox_stage_1/common/utils/error/err/sign_in_err.dart';
import 'package:aerox_stage_1/domain/models/aerox_user.dart';
import 'package:aerox_stage_1/domain/use_cases/login/check_user_signed_in_usecase.dart';
import 'package:aerox_stage_1/features/feature_login/repository/login_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mock_types.dart';

late LoginRepository loginRepository;
late CheckUserSignedInUsecase checkUserSignedInUsecase;
late User mockUser;
final user = AeroxUser(name: 'name', email: 'email');
void main() {
  setUp((){
    loginRepository = MockLoginRepo();
    mockUser = MockFirebaseUser();
    checkUserSignedInUsecase = CheckUserSignedInUsecase(loginRepo: loginRepository);
  });
  group('check user signed in usecase ...', () {
    test('user is already signed in, return [ User ]', ()async {
    () async{
      when(
      () => loginRepository.checkUserSignedIn()
    ).thenAnswer( ( _ ) async => Right(user ) );
    final result = checkUserSignedInUsecase();
    expect(result, equals(user));
    };
  });
    test('user is not already signed in, return [ SignInErr ]', ()async {
    () async{
      when(
      () => loginRepository.checkUserSignedIn()
    ).thenAnswer((_) async => Left( SignInErr(errMsg: 'hola', statusCode: 1) ) );
    final result = checkUserSignedInUsecase();
    expect(result, equals(user));
    };
  });
  });
}