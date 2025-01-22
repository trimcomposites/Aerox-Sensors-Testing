import 'package:aerox_stage_1/domain/use_cases/login/sign_in_user_usecase.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/login_repository.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/remote_barrel.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock_types.dart';


  late SignInUserUsecase usecase;
  late LoginRepository repository;
  late User mockUser;

void main() {

  setUp((){
    repository = MockLoginRepo();
    usecase = SignInUserUsecase(loginRepo: repository);
    mockUser = MockFirebaseUser();
  });

  final params = SignInUserUsecaseParams.empty();
  test(' sign in user use case  should return User', () async{

    //arrage

    when(() => repository.signInUser(
      signInType: params.signInType,
      userData: any( named: 'userData' )
      )).thenAnswer((_) async => Right(mockUser));

    //act

    final result = await usecase( params );

    //assert
    expect(result, equals(  Right<dynamic, User>( mockUser ) ));
     verify(() => repository.signInUser(
       signInType: params.signInType, 
       userData: params.userData
     )).called(1);
     verifyNoMoreInteractions( repository );

  });


}