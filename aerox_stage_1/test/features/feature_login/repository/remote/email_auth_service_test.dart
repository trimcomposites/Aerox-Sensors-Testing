import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/common/utils/error/err/sign_in_err.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/remote_barrel.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mock_types.dart';


late EmailAuthService emailAuthService;
late FirebaseAuth firebaseAuth;

void main() {

  setUp((){
    firebaseAuth = MockFirebaseAuth2();
    emailAuthService = EmailAuthService(firebaseAuth: firebaseAuth);
  });


  final userData = UserData(name: 'name', email: 'email', password: 'password');
  final userCredential = MockUserCredential();
  final user = MockFirebaseUser();

  group(' sign in with email method ', () {
  test('success email sign in, should return [ User ]', () async {

    when(() => firebaseAuth.signInWithEmailAndPassword(
      email: userData.email,
      password: userData.password
    )).thenAnswer((_) async => userCredential );

    when(() => userCredential.user
    ,).thenReturn( user );

    final result = await emailAuthService.signInWithEmail( userData: userData  );

    //assert
    expect(result, equals( Right<Err, User>( user ) ));
    verify(() => firebaseAuth.signInWithEmailAndPassword(
      email: userData.email,
      password: userData.password
    )).called(1);
    verifyNoMoreInteractions( firebaseAuth );

    });
    test('when user is null => failure email sign in, should return [ SignInErr ]', () async {

      when(() => firebaseAuth.signInWithEmailAndPassword(
        email: userData.email,
        password: userData.password
      )).thenAnswer((_) async => userCredential );

      when(() => userCredential.user
      ,).thenReturn( null );

      final result = await emailAuthService.signInWithEmail( userData: userData  );

      //assert
      expect(result, isA<Left<Err, User>>() );
      verify(() => firebaseAuth.signInWithEmailAndPassword(
        email: userData.email,
        password: userData.password
      )).called(1);
      verifyNoMoreInteractions( firebaseAuth );

    });
    test('when throw [ FirebaseAuthException ] => failure email sign in, should return [ SignInErr ]', () async{

      when(() => firebaseAuth.signInWithEmailAndPassword(
        email: userData.email,
        password: userData.password
      )).thenThrow((_) async => FirebaseAuthException(code: any( named: 'code' )) );

      final result = await emailAuthService.signInWithEmail( userData: userData  );

      //assert
      expect(result, isA<Left<Err, User>>() );
      verify(() => firebaseAuth.signInWithEmailAndPassword(
        email: userData.email,
        password: userData.password
      )).called(1);
      verifyNoMoreInteractions( firebaseAuth );

    });
    test('when throw [ UnhandledException ] => failure email sign in, should return [ SignInErr ]', () async {
      when(() => firebaseAuth.signInWithEmailAndPassword(
        email: userData.email,
        password: userData.password
      )).thenThrow((_) async => Exception() );

      final result = await emailAuthService.signInWithEmail( userData: userData  );

      //assert
      expect(result, isA<Left<Err, User>>() );
      verify(() => firebaseAuth.signInWithEmailAndPassword(
        email: userData.email,
        password: userData.password
      )).called(1);
      verifyNoMoreInteractions( firebaseAuth );

    });
  });

  group(' sign out method ', ()  {
    test('sign out success, must return [void] ', () async {
      when(() => firebaseAuth.signOut(
      )).thenAnswer((_) async => Right( null ));

      //act

      final result = await emailAuthService.signOut();

      expect(result, isA<Right<Err, void>>());
      verify(() => firebaseAuth.signOut(),).called(1);
      verifyNoMoreInteractions( firebaseAuth );

    });

    test('sign out failure, must return [Err] ', () async {
      when(() => firebaseAuth.signOut(
      )).thenThrow((_) async =>(_) async => Exception() );

      //act

      final result = await emailAuthService.signOut();

      expect(result, isA<Left<Err, void>>());
      verify(() => firebaseAuth.signOut(),).called(1);
      verifyNoMoreInteractions( firebaseAuth );

    });

    

  });



}