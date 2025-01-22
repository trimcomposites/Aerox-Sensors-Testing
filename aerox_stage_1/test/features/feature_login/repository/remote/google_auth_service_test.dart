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
  //final authCredential = MockAuthCredential();
  final userCredential = MockUserCredential();
  final googleSignInAccount = MockGoogleSignInAccount();
  final googleSignInAuthentication = MockGoogleSignInAuthentication();
  final user = MockFirebaseUser();
  final idToken = 'idToken';
  final accesToken = 'accessToken';

group(' sign in with google method ', () {
  test('success google sign in, should return [ User ]', () async {
    registerFallbackValue(AuthCredential(
      providerId: 'test',
      signInMethod: 'test',
    ));

    when(() => googleSignIn.signIn(
    )).thenAnswer((_) async => googleSignInAccount );

    when(() => googleSignInAccount.authentication).thenAnswer((_) async => googleSignInAuthentication);
    when(() => googleSignInAuthentication.accessToken).thenReturn( accesToken );
    when(() => googleSignInAuthentication.idToken).thenReturn( idToken);

    when(() => firebaseAuth.signInWithCredential( any() )).thenAnswer((_) async => userCredential);
    
    
    when(() => userCredential.user).thenReturn( user );

    final result = await googleAuthService.signInWithGoogle();

    //assert
    expect(result, equals( Right<Err, User>( user ) ));
    verify(() => googleSignIn.signIn()
    ).called(1);
    verify(() => firebaseAuth.signInWithCredential( any())
    ).called(1);
    verifyNoMoreInteractions( firebaseAuth );

    });
  test('when GoogleSigninAccount is null => failure google sign in, should return [ SignInErr ]', () async {
    registerFallbackValue(AuthCredential(
      providerId: 'test',
      signInMethod: 'test',
    ));

    when(() => googleSignIn.signIn(
    )).thenAnswer((_) async => null );

    when(() => googleSignInAccount.authentication).thenAnswer((_) async => googleSignInAuthentication);
    when(() => googleSignInAuthentication.accessToken).thenReturn( accesToken );
    when(() => googleSignInAuthentication.idToken).thenReturn( idToken);

    when(() => firebaseAuth.signInWithCredential( any() )).thenAnswer((_) async => userCredential);
    
    
    when(() => userCredential.user).thenReturn( user );

    final result = await googleAuthService.signInWithGoogle();

    //assert
    expect(result, isA< Left<Err, User>>());
    verify(() => googleSignIn.signIn()
    ).called(1);
    verifyNever(() => firebaseAuth.signInWithCredential( any())
    );
    verifyNoMoreInteractions( firebaseAuth );

    });
    
  test('when User is null => failure google sign in, should return [ SignInErr ]', () async {
    registerFallbackValue(AuthCredential(
      providerId: 'test',
      signInMethod: 'test',
    ));

    when(() => googleSignIn.signIn(
    )).thenAnswer((_) async => googleSignInAccount  );

    when(() => googleSignInAccount.authentication).thenAnswer((_) async => googleSignInAuthentication);
    when(() => googleSignInAuthentication.accessToken).thenReturn( accesToken );
    when(() => googleSignInAuthentication.idToken).thenReturn( idToken);

    when(() => firebaseAuth.signInWithCredential( any() )).thenAnswer((_) async => userCredential);
    
    
    when(() => userCredential.user).thenReturn( null );

    final result = await googleAuthService.signInWithGoogle();

    //assert
    expect(result, isA< Left<Err, User>>());
    verify(() => googleSignIn.signIn()
    ).called(1);
    verify(() => firebaseAuth.signInWithCredential( any())
    ).called(1);
    verifyNoMoreInteractions( firebaseAuth );

    });
    
  test('when throws [ UnhandledException ]=> failure google sign in, should return [ SignInErr ]', () async {
    registerFallbackValue(AuthCredential(
      providerId: 'test',
      signInMethod: 'test',
    ));

    when(() => googleSignIn.signIn(
    )).thenThrow( Exception()  );

    when(() => googleSignInAccount.authentication).thenAnswer((_) async => googleSignInAuthentication);
    when(() => googleSignInAuthentication.accessToken).thenReturn( accesToken );
    when(() => googleSignInAuthentication.idToken).thenReturn( idToken);

    when(() => firebaseAuth.signInWithCredential( any() )).thenAnswer((_) async => userCredential);
    
    
    when(() => userCredential.user).thenReturn( null );

    final result = await googleAuthService.signInWithGoogle();

    //assert
    expect(result, isA< Left<Err, User>>());
    verify(() => googleSignIn.signIn()
    ).called(1);
    verifyNever(() => firebaseAuth.signInWithCredential( any())
    );
    verifyNoMoreInteractions( firebaseAuth );

    });
    

  });

  group('google sign out', (){
    test('sign out success, should return [ void ]', () async {
      when(() => googleSignIn.signOut()).thenAnswer((_) async => null);
      when(() => firebaseAuth.signOut()).thenAnswer((_) async => Right( null ) );


      final result = await googleAuthService.signOut();

      // Assert: Verificar que el resultado es un Right<void>

      expect(result, isA<Right<Err, void>>());
      verify(() => googleSignIn.signOut(),).called(1);
      verify(() => firebaseAuth.signOut(),).called(1);
      verifyNoMoreInteractions( firebaseAuth );
    });
  });
}
 