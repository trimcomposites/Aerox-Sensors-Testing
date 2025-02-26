import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/common/utils/error/err/sign_in_err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/aerox_user.dart';
import 'package:aerox_stage_1/domain/use_cases/login/register_user_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/sign_in_user_usecase.dart';
import 'package:aerox_stage_1/features/feature_login/repository/login_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mock_types.dart';

late RegisterUserUseCase usecase;
late LoginRepository loginRepo;
//late User mockUser;
late FirebaseAuth auth;

Future<void> main() async {

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp((){
    loginRepo = MockLoginRepo();
    usecase = RegisterUserUseCase(loginRepo: loginRepo);
    //mockUser = MockFirebaseUser();
  });


  final params = SignInUserUsecaseParams.empty();
  final user = AeroxUser(name: 'name', email: 'email', id: 'id');

  group('create users', (){
    test( 'call login repo and return user if values'
    'are correct and acc is created' ,
    () async{
      when(
      () => loginRepo.registerWithEmail(
        params.user!
        )
    ).thenAnswer( ( _ ) async => Right( user ) );

    final result = await usecase( params.user! );
    expect(result, equals(  Right<dynamic, AeroxUser>( user ) ));
    verify(() =>  loginRepo.registerWithEmail( params.user! )).called(1);
    verifyNoMoreInteractions( loginRepo );
    });

  test( 'should return SignInErr' , 
    ()async{

    final expectedErr = SignInErr( errMsg: '', statusCode: 1);
      when(
      () => loginRepo.registerWithEmail(
        params.user!
        )
    ).thenAnswer( (_) async => Left( expectedErr ));

    final result = await usecase( params.user!);
    
    expect(result, equals( Left<Err, dynamic>( expectedErr)));
    verify(() =>  loginRepo.registerWithEmail( params.user! )).called(1);
    verifyNoMoreInteractions( loginRepo );
    });


  });
  




  

}