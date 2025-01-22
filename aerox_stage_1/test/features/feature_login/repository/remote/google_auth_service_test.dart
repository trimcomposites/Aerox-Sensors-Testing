import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/remote_barrel.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mock_types.dart';

late GoogleAuthService googleAuthService;
late FirebaseAuth firebaseAuth;
late GoogleSignIn googleSignIn;

void main() {

  setUp((){
    firebaseAuth = MockFirebaseAuth2();
    googleSignIn = MockGoogleSignIn();
    googleAuthService = GoogleAuthService(
      auth: firebaseAuth,
      googleSignIn: googleSignIn
    );
  });


  final userData = UserData(name: 'name', email: 'email', password: 'password');
  final authCredential = MockAuthCredential();
  final userCredential = MockUserCredential();
  final googleSignInAccount = MockGoogleSignInAccount();
  final googleSignInAuthentication = MockGoogleSignInAuthentication();
  final user = MockFirebaseUser();
  final idToken = 'idToken';
  final accesToken = 'accessToken';

group(' sign in with google method ', () {
  test('success google sign in, should return [ User ]', () async {

    when(() => googleSignIn.signIn(
    )).thenAnswer((_) async => googleSignInAccount );

    when(() => googleSignInAccount.authentication).thenAnswer((_) async => googleSignInAuthentication);
    when(() => googleSignInAuthentication.accessToken).thenReturn( accesToken );
    when(() => googleSignInAuthentication.idToken).thenReturn( idToken);

  // Verifica que el credential se crea correctamente con los tokens de acceso e ID

    when(() => firebaseAuth.signInWithCredential(authCredential)).thenAnswer((_) async => userCredential);
    
    
    when(() => userCredential.user).thenReturn( user );

    final result = await googleAuthService.signInWithGoogle();

    //assert
    expect(result, equals( Right<Err, User>( user ) ));
    verify(() => googleSignIn.signIn()
    ).called(1);
    verifyNoMoreInteractions( firebaseAuth );

    });
    test('when user is null => failure google sign in, should return [ SignInErr ]', () async {

      when(() => firebaseAuth.signInWithEmailAndPassword(
        email: userData.email,
        password: userData.password
      )).thenAnswer((_) async => userCredential );

      when(() => userCredential.user
      ,).thenReturn( null );

      final result = await googleAuthService.signInWithGoogle();

      //assert
      expect(result, isA<Left<Err, User>>() );
      verify(() => firebaseAuth.signInWithEmailAndPassword(
        email: userData.email,
        password: userData.password
      )).called(1);
      verifyNoMoreInteractions( firebaseAuth );

    });
    test('when throw [ FirebaseAuthException ] => failure google sign in, should return [ SignInErr ]', () async{

      when(() => firebaseAuth.signInWithEmailAndPassword(
        email: userData.email,
        password: userData.password
      )).thenThrow((_) async => FirebaseAuthException(code: any( named: 'code' )) );

      final result = googleAuthService.signInWithGoogle();

      //assert
      expect(result, isA<Left<Err, User>>() );
      verify(() => firebaseAuth.signInWithEmailAndPassword(
        email: userData.email,
        password: userData.password
      )).called(1);
      verifyNoMoreInteractions( firebaseAuth );

    });
  });

  group('google sign out', (){
    test('sign out success, should return [ void ]', () async {
      when(() => googleSignIn.signOut()).thenAnswer((_) async => null);
      when(() => firebaseAuth.signOut()).thenAnswer((_) async => Right( null ) );

      // Act: Llamar a la función signOut
      final result = await googleAuthService.signOut();

      // Assert: Verificar que el resultado es un Right<void>

      expect(result, isA<Right<Err, void>>());
      verify(() => googleSignIn.signOut(),).called(1);
      verify(() => firebaseAuth.signOut(),).called(1);
      verifyNoMoreInteractions( firebaseAuth );
    });
  });
}
 