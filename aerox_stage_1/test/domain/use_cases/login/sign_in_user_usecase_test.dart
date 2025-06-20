import 'package:aerox_stage_1/domain/models/aerox_user.dart';
import 'package:aerox_stage_1/domain/use_cases/login/sign_in_user_usecase.dart';
import 'package:aerox_stage_1/features/feature_login/repository/login_repository.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/remote_barrel.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mock_types.dart';


  late SignInUserUseCase usecase;
  late LoginRepository repository;
  //late User mockUser;

void main() {

  setUp((){
    repository = MockLoginRepo();
    usecase = SignInUserUseCase(loginRepo: repository);
    //mockUser = MockFirebaseUser();
  });
  final user = AeroxUser(name: 'name', email: 'email', id: 'id');

  final params = SignInUserUsecaseParams(signInType: EmailSignInType.email, user: user);
  test(' sign in user use case  should return AeroxUser', () async{

    //arrage

    when(() => repository.signInUser(
      signInType: params.signInType,
      aeroxUser: user
      )).thenAnswer((_) async => Right( user ));

    //act

    final result = await usecase( params );

    //assert
    expect(result, equals(  Right<dynamic, AeroxUser>( user ) ));
     verify(() => repository.signInUser(
       signInType: params.signInType, 
       aeroxUser: params.user
     )).called(1);
     verifyNoMoreInteractions( repository );

  });


}