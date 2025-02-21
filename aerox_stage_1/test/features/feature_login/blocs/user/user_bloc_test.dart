import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/common/utils/error/err/sign_in_err.dart';
import 'package:aerox_stage_1/domain/models/aerox_user.dart';
import 'package:aerox_stage_1/domain/use_cases/login/check_user_signed_in_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/register_user_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/reset_password_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/sign_in_user_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/sign_out_user_usecase.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/remote_barrel.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../domain/use_cases/login/reset_password_usecase_test.dart';
import '../../../../mock_types.dart';

void main(){

  late UserBloc userBloc;
  late SignInUserUseCase signInUserUsecase;
  late SignOutUserUseCase signOutUserUsecase;
  late RegisterUserUseCase registerUserUsecase;
  late CheckUserSignedInUseCase checkUserSignedInUsecase;
  late ResetPasswordUseCase resetPasswordUsecase;
  final user = AeroxUser(name: 'name', email: 'email');
  setUp((){
    signInUserUsecase = MockSignInUserUseCase();
    signOutUserUsecase = MockSignOutUserUsecase();
    registerUserUsecase = MockRegisterUserUsecase();
    checkUserSignedInUsecase = MockCheckUserSignedInUsecase();
    resetPasswordUsecase = MockResetPasswordUsecase();

    userBloc = UserBloc(
      registerUseCase: registerUserUsecase, 
      signInUsecase: signInUserUsecase, 
      signOutUseCase: signOutUserUsecase,
      checkUserSignedInUsecase: checkUserSignedInUsecase,
      resetPasswordUsecase: resetPasswordUsecase

    );
  });
  setUpAll(() {
    registerFallbackValue( SignInUserUsecaseParams(signInType: EmailSignInType.email, user: AeroxUser(name: 'name', email: 'email', password: 'password')) );
  });
  tearDown( () => userBloc.close() );


  final aeroxUser = AeroxUser(name: 'name', email: 'email', password: 'password');
  final emailSignInUserParams= SignInUserUsecaseParams(signInType: EmailSignInType.email, user: aeroxUser);
  final googleSignInUserParams= SignInUserUsecaseParams(signInType: EmailSignInType.google, user: aeroxUser);
  group(  'sign in email', (){
    blocTest<UserBloc, UserState>('signin email success,emits [ user: [ User ], errormsg: [ null ] ]', 
      build: () {
      when(() => signInUserUsecase(any()))
      .thenAnswer((_) async => Right(user));
        return userBloc;
      },
      act: (userBloc) => userBloc.add( OnEmailSignInUser( email: aeroxUser.email, password: aeroxUser.password! ) ),
      expect: () => [
        UserState( user: null,uiState: UIState.loading() ),
        UserState( user: user,uiState: UIState.success( next: '/home' ),  ),
      ],
    );

    blocTest<UserBloc, UserState>('signin email fails, emits [ user: [ null ], errormsg: [ String ] ]', 
      build: () {
        when(() => signInUserUsecase( any() )).thenAnswer( ( _ ) async => Left( SignInErr( errMsg: '', statusCode: 1 ) ) );
        return userBloc;
      },
      act: (bloc) => bloc.add( OnEmailSignInUser( email: aeroxUser.email, password: aeroxUser.password! ) ),
      
      expect: () => [
                UserState( user: null,uiState: UIState.loading() ),
        UserState( user: null, uiState: UIState.error( '' ) ),
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
        UserState( user: null, uiState: UIState.loading() ),
        UserState( user: null, uiState: UIState.success( next: '/' ) ),
      ],
    );

    blocTest<UserBloc, UserState>('signOut email fails, emits [ user: [ User ], errormsg: [ String ] ]', 
      build: () {
        when(() => signOutUserUsecase( EmailSignInType.email )).thenAnswer( ( _ ) async => Left( SignInErr(errMsg: 'text', statusCode: 1) ) );
        return userBloc;
      },
      act: (bloc) => bloc.add( OnEmailSignOutUser() ),
      
      expect: () => [
        UserState( user: null, uiState: UIState.loading() ),
        UserState( user: null, uiState: UIState.error( 'text') )
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
        UserState( user: null, uiState: UIState.loading() ),
        UserState( user: user, uiState: UIState.success(  next: '/home' ) ),
      ],

    );

    blocTest<UserBloc, UserState>('google signOut fails, emits [ user: [ User ], errormsg: [ String ] ]', 
      build: () {
        when(() => signOutUserUsecase( EmailSignInType.google )).thenAnswer( ( _ ) async => Left( SignInErr(errMsg: '', statusCode: 1) ) );
        return userBloc;
      },
      act: (bloc) => bloc.add( OnGoogleSignOutUser() ),
      
      expect: () => [
        UserState( user: null,uiState: UIState.loading( ) ),
        UserState( user: null,uiState: UIState.error( '' ) ),
      ],
    );
  });
  group('On check user is signed in', (){
  blocTest<UserBloc, UserState>('user is signed in emits [ user: [ User ] ]', 
        build: () {
          when(() => checkUserSignedInUsecase() ).thenAnswer((_) async => right( user ));
          return userBloc;
        },
        act: (bloc) => bloc.add( OnCheckUserIsSignedIn() ),
        
        expect: () => [
          UserState( user: null, uiState: UIState.loading()),
          UserState( user: user, uiState: UIState.success( next: '/home' )),
        ],
      );
  
  blocTest<UserBloc, UserState>('user is not signed in emits [ user: [ null ] ]', 
        build: () {
          when(() => checkUserSignedInUsecase() ).thenAnswer((_) async => left( SignInErr(errMsg: 'errMsg', statusCode: 6) ));
          return userBloc;
        },
        act: (bloc) => bloc.add( OnCheckUserIsSignedIn() ),
        
        expect: () => [
          UserState( user: null, uiState: UIState.loading( ) ),
          UserState( user: null, uiState: UIState.success() ),
        ],
  );
  });
  group('On reset password', (){
  blocTest<UserBloc, UserState>('reset password success, emits [ errorMessage: [ String ] ', 
        build: () {
          when(() => resetPasswordUsecase( email ) ).thenAnswer((_) async => Right( null ));
          return userBloc;
        },
        act: (bloc) => bloc.add( OnPasswordReset( email: email ) ),
        
        expect: () => [
          UserState( user: null, uiState: UIState.loading( ) ),
          UserState( user: null, uiState: UIState.idle() ),
        ],
      );
  
  blocTest<UserBloc, UserState>('reset password success, failure [ errorMessage: [ String ] ]', 
      build: () {
          when(() => resetPasswordUsecase( email ) ).thenAnswer((_) async => Left( SignInErr(errMsg: '', statusCode: 1) ));
          return userBloc;
        },
        act: (bloc) => bloc.add( OnPasswordReset( email: email ) ),
        
        expect: () => [
          UserState( user: null,uiState: UIState.loading( ) ),
          UserState( user: null,uiState: UIState.error( '' ) ),
        ],
      );
  });

  // blocTest<UserBloc, UserState>('On delete error message, emits [ errorMessage: [ null ] ]', 
  //       build: () => userBloc,
  //       act: (bloc) => bloc.add( OnDeleteErrorMsg() ),
        
  //       expect: () => [
  //         UserState( uiState: UIState.success() )
  //       ],
  // );

}

  

