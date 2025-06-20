import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/common/utils/error/err/sign_in_err.dart';
import 'package:aerox_stage_1/domain/use_cases/login/sign_out_user_usecase.dart';
import 'package:aerox_stage_1/features/feature_login/repository/login_repository.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/remote_barrel.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mock_types.dart';


late SignOutUserUseCase usecase;
late LoginRepository loginRepository;
void main() {

  setUp((){
    loginRepository = MockLoginRepo();
    usecase = SignOutUserUseCase(loginRepo: loginRepository );

  });
  
  const defSignInType = EmailSignInType.email;

  group('sign out user usecase ...', () {
    test(' sign out success, should return [ void ] ', () async {

      //arrange
      when(() => loginRepository.signOutUser(
      signInType: defSignInType,
      )).thenAnswer((_) async => Right( null ));

    //act

    final result = await usecase( EmailSignInType.email );

    //assert
    expect(result, equals(  Right<Err, void>( null ) ));
     verify(() => loginRepository.signOutUser(
       signInType: defSignInType,
     )).called(1);
     verifyNoMoreInteractions( loginRepository );

    });
    test(' sign out fail, should return [ SignInErr ] ', () async{

      final expectedErr = SignInErr(errMsg: 'errMsg', statusCode: 1);
      //arrange
      when(() => loginRepository.signOutUser(
      signInType: defSignInType,
      )).thenAnswer((_) async => Left( expectedErr ));

      //act

      final result = await usecase( EmailSignInType.email );

    //assert
    expect(result, equals(  Left<Err, void>( expectedErr )));
     verify(() => loginRepository.signOutUser(
       signInType: defSignInType,
     )).called(1);
     verifyNoMoreInteractions( loginRepository );
    });

  });
}