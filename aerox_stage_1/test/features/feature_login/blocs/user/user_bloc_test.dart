import 'package:aerox_stage_1/common/utils/error/err/sign_in_err.dart';
import 'package:aerox_stage_1/domain/use_cases/login/register_user_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/sign_in_user_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/sign_out_user_usecase.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/remote_barrel.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mock_types.dart';

void main(){

  late UserBloc userBloc;
  late SignInUserUsecase signInUserUsecase;
  late SignOutUserUsecase signOutUserUsecase;
  late RegisterUserUsecase registerUserUsecase;
  final user = MockFirebaseUser();

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


  final userData = UserData(name: 'name', email: 'email', password: 'password');
  final emailSignInUserParams= SignInUserUsecaseParams(signInType: EmailSignInType.email, userData: userData);
  final googleSignInUserParams= SignInUserUsecaseParams(signInType: EmailSignInType.google, userData: userData);
  group(  'sign in email', (){
    blocTest<UserBloc, UserState>('signin email success,emits [ user: [ User ], errormsg: [ null ] ]', 
      build: () {
      when(() => signInUserUsecase(any()))
      .thenAnswer((_) async => Right(user));
        return userBloc;
      },
      act: (userBloc) => userBloc.add( OnEmailSignInUser( email: userData.email, password: userData.password ) ),
      expect: () => [
        UserState( user: user, errorMessage: null ),
      ],
    );

    blocTest<UserBloc, UserState>('signin email fails, emits [ user: [ null ], errormsg: [ String ] ]', 
      build: () {
        when(() => signInUserUsecase( any() )).thenAnswer( ( _ ) async => Left( SignInErr( errMsg: '', statusCode: 1 ) ) );
        return userBloc;
      },
      act: (bloc) => bloc.add( OnEmailSignInUser( email: userData.email, password: userData.password ) ),
      
      expect: () => [
        UserState( user: null, errorMessage: '' ),
      ],
    );
  });

  group(  'sign out email', (){
    blocTest<UserBloc, UserState>('signOut email success,emits [ user: [ null ], errormsg: [ null ] ]', 
      build: () {
        when(() => signOutUserUsecase( EmailSignInType.email )).thenAnswer( ( _ ) async => Right( null ) );
        return userBloc;
      },
      act: (bloc) => bloc.add( OnEmailSignOutUser() ),
      
      expect: () => [
        UserState( user: null, errorMessage: null ),
      ],
    );

    blocTest<UserBloc, UserState>('signOut email fails, emits [ user: [ User ], errormsg: [ String ] ]', 
      build: () {
        when(() => signOutUserUsecase( EmailSignInType.email )).thenAnswer( ( _ ) async => Left( SignInErr(errMsg: '', statusCode: 1) ) );
        return userBloc;
      },
      act: (bloc) => bloc.add( OnEmailSignOutUser() ),
      
      expect: () => [
        UserState( user: null, errorMessage: '' )
      ],
    );
  });
  group(  'google sign in', (){
    blocTest<UserBloc, UserState>('Google sign in success,emits [ user: [ User ], errormsg: [ null ] ]', 
      build: () {
        when(() => signInUserUsecase( any())).thenAnswer( ( _ ) async => Right( user ) );
        return userBloc;
      },
      act: (bloc) => bloc.add( OnGoogleSignInUser() ),
      
      expect: () => [
        UserState( user: user, errorMessage: null )
      ],

    );

    blocTest<UserBloc, UserState>('google signOut fails, emits [ user: [ User ], errormsg: [ String ] ]', 
      build: () {
        when(() => signOutUserUsecase( EmailSignInType.google )).thenAnswer( ( _ ) async => Left( SignInErr(errMsg: '', statusCode: 1) ) );
        return userBloc;
      },
      act: (bloc) => bloc.add( OnGoogleSignOutUser() ),
      
      expect: () => [
        UserState( user: null, errorMessage: '' )
      ],
    );
  });

}

  

