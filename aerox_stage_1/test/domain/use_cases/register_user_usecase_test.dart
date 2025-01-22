import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/common/utils/error/err/sign_in_err.dart';
import 'package:aerox_stage_1/common/utils/exceptions/sign_in_exception.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/use_cases/register_user_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/sign_in_user_usecase.dart';
import 'package:aerox_stage_1/domain/user_data.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/login_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_types.dart';

late RegisterUserUsecase usecase;
late LoginRepository loginRepo;
late User mockUser;
late FirebaseAuth auth;

Future<void> main() async {

  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    auth = MockFirebaseAuth();
  });
  setUp((){
    loginRepo = MockLoginRepo();
    usecase = RegisterUserUsecase(loginRepo: loginRepo);
    mockUser = MockFirebaseUser();
  });


  final params = SignInUserUsecaseParams.empty();

  group('create users', (){
    test( 'call login repo and return user if values'
    'are correct and acc is created' ,
    () async{
      when(
      () => loginRepo.registerWithEmail(
        params.userData!
        )
    ).thenAnswer( ( _ ) async => Right( mockUser ) );

    final result = await usecase( params.userData! );
    expect(result, equals(  Right<dynamic, User>( mockUser ) ));
    verify(() =>  loginRepo.registerWithEmail( params.userData! )).called(1);
    verifyNoMoreInteractions( loginRepo );
    });

  test( 'should return SignInErr' , 
    ()async{

    final expectedErr = SignInErr( errMsg: '', statusCode: 1);
      when(
      () => loginRepo.registerWithEmail(
        params.userData!
        )
    ).thenAnswer( (_) async => Left( expectedErr ));

    final result = await usecase( params.userData!);
    
    expect(result, equals( Left<Err, dynamic>( expectedErr)));
    verify(() =>  loginRepo.registerWithEmail( params.userData! )).called(1);
    verifyNoMoreInteractions( loginRepo );
    });


  });
  




  

}