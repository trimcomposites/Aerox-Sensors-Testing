import 'package:aerox_stage_1/domain/use_cases/register_user_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/sign_in_user_usecase.dart';
import 'package:aerox_stage_1/domain/user_data.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/login_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
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

  });




  

}