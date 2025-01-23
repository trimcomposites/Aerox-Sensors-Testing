import 'package:aerox_stage_1/domain/models/aerox_user.dart';
import 'package:aerox_stage_1/domain/use_cases/login/sign_in_user_usecase.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/login_repository.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/remote_barrel.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mock_types.dart';


  late SignInUserUsecase usecase;
  late LoginRepository repository;
  //late User mockUser;

void main() {

  setUp((){
    repository = MockLoginRepo();
    usecase = SignInUserUsecase(loginRepo: repository);
    //mockUser = MockFirebaseUser();
  });
    final user = AeroxUser(name: 'name', email: 'email');

  final params = SignInUserUsecaseParams.empty();
  test(' sign in user use case  should return AeroxUser', () async{

    //arrage

    when(() => repository.signInUser(
      signInType: params.signInType,
      aeroxUser: any( named: 'userData' )
      )).thenAnswer((_) async => Right(user));

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