import 'package:aerox_stage_1/common/utils/error/err/sign_in_err.dart';
import 'package:aerox_stage_1/domain/use_cases/login/register_user_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/sign_in_user_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/sign_out_user_usecase.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/remote_barrel.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mock_types.dart';

void main(){

  late UserBloc userBloc;
  late SignInUserUsecase signInUserUsecase;
  late SignOutUserUsecase signOutUserUsecase;
  late RegisterUserUsecase registerUserUsecase;
  
  setUp((){
    signInUserUsecase = MockSignInUserUseCase();
    signOutUserUsecase = MockSignOutUserUsecase();
    registerUserUsecase = MockRegisterUserUsecase();
    userBloc = UserBloc(
      registerUseCase: registerUserUsecase, 
      signInUsecase: signInUserUsecase, 
      signOutUseCase: signOutUserUsecase 
    );
  });
  setUpAll(() {
    registerFallbackValue( SignInUserUsecaseParams(signInType: EmailSignInType.email, userData: UserData(name: 'name', email: 'email', password: 'password')) );
  });
  tearDown( () => userBloc.close() );

  void main() {
  final user = MockFirebaseUser();

  group(  'success sign in email', (){
    blocTest<UserBloc, UserState>('signin email success,emits [ user: [ User ], errormsg: [ null ] ]', 
      build: () {
        when(() => signInUserUsecase( any( named: 'userData' ) )).thenAnswer( ( _ ) async => Right( user ) );
        return userBloc;
      },
      act: (bloc) => bloc.add( OnEmailSignInUser( email: any( named: 'email' ), password: any( named: 'password' ) ) ),
      
      expect: () => [
        UserState( user: user ),
        UserState( errorMessage: null )
      ],
      verify: ( _ ) => signInUserUsecase( any( named: 'userData' ) )
    );

    blocTest<UserBloc, UserState>('signin email fails, emits [ user: [ null ], errormsg: [ String ] ]', 
      build: () {
        when(() => signInUserUsecase( any( named: 'userData' ) )).thenAnswer( ( _ ) async => Left( SignInErr( errMsg: '', statusCode: 1 ) ) );
        return userBloc;
      },
      act: (bloc) => bloc.add( OnEmailSignInUser( email: any( named: 'email' ), password: any( named: 'password' ) ) ),
      
      expect: () => [
        UserState( user: null ),
        UserState( errorMessage: '' )
      ],
      verify: ( _ ) => signInUserUsecase( any( named: 'userData' ) )
    );
  });

}

  

}