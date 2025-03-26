import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/common/utils/error/err/sign_in_err.dart';
import 'package:aerox_stage_1/domain/models/aerox_user.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/remote_barrel.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mock_types.dart';

late EmailAuthService emailAuthService;
late FirebaseAuth firebaseAuth;

void main() {
  setUp(() {
    firebaseAuth = MockFirebaseAuth2();
    emailAuthService = EmailAuthService(firebaseAuth: firebaseAuth);
    
    // Registrar valores por defecto para evitar errores de Mocktail
    registerFallbackValue(MockUserCredential());
    registerFallbackValue(MockFirebaseUser());
  });

  final aeroxUser = AeroxUser(name: 'name', email: 'email', id: '1', password: 'password123');
  final userCredential = MockUserCredential();
  final user = MockFirebaseUser();

  group('Sign in with email', () {
    test('Success case: Should return [AeroxUser]', () async {
      when(() => firebaseAuth.signInWithEmailAndPassword(
            email: aeroxUser.email,
            password: aeroxUser.password!,
          )).thenAnswer((_) async => userCredential);

      when(() => userCredential.user).thenReturn(user);
      when(() => user.uid).thenReturn(aeroxUser.id);
      when(() => user.email).thenReturn(aeroxUser.email);
      when(() => user.updateDisplayName(any())).thenAnswer((_) async => Future.value());
        when(() => user.reload()).thenAnswer((_) async => Future.value());
      final result = await emailAuthService.signInWithEmail(aeroxUser: aeroxUser);

      expect(result, isA<Right<Err, AeroxUser>>());
      verify(() => firebaseAuth.signInWithEmailAndPassword(
          email: aeroxUser.email, password: aeroxUser.password!)).called(1);
    });

    test('Failure: User is null, should return [SignInErr]', () async {
      when(() => firebaseAuth.signInWithEmailAndPassword(
            email: aeroxUser.email,
            password: aeroxUser.password!,
          )).thenAnswer((_) async => userCredential);

      when(() => userCredential.user).thenReturn(null);

      final result = await emailAuthService.signInWithEmail(aeroxUser: aeroxUser);

      expect(result, isA<Left<Err, AeroxUser>>());
    });

    test('Failure: FirebaseAuthException, should return [SignInErr]', () async {
      when(() => firebaseAuth.signInWithEmailAndPassword(
            email: aeroxUser.email,
            password: aeroxUser.password!,
          )).thenThrow(FirebaseAuthException(code: 'user-not-found'));

      final result = await emailAuthService.signInWithEmail(aeroxUser: aeroxUser);

      expect(result, isA<Left<Err, AeroxUser>>());
    });

    test('Failure: Unhandled Exception, should return [SignInErr]', () async {
      when(() => firebaseAuth.signInWithEmailAndPassword(
            email: aeroxUser.email,
            password: aeroxUser.password!,
          )).thenThrow(Exception());

      final result = await emailAuthService.signInWithEmail(aeroxUser: aeroxUser);

      expect(result, isA<Left<Err, AeroxUser>>());
    });
  });

  group('Create user with email', () {
    test('Success case: Should return [AeroxUser]', () async {
      when(() => firebaseAuth.createUserWithEmailAndPassword(
            email: aeroxUser.email,
            password: aeroxUser.password!,
          )).thenAnswer((_) async => userCredential);

      when(() => userCredential.user).thenReturn(user);
      when(() => user.uid).thenReturn(aeroxUser.id);
      when(() => user.email).thenReturn(aeroxUser.email);
      when(() => user.updateDisplayName(any())).thenAnswer((_) async => Future.value());
      final result = await emailAuthService.createUserWithEmail(aeroxUser: aeroxUser);

      expect(result, isA<Right<Err, AeroxUser>>());
    });

    test('Failure: User is null, should return [SignInErr]', () async {
      when(() => firebaseAuth.createUserWithEmailAndPassword(
            email: aeroxUser.email,
            password: aeroxUser.password!,
          )).thenAnswer((_) async => userCredential);

      when(() => userCredential.user).thenReturn(null);

      final result = await emailAuthService.createUserWithEmail(aeroxUser: aeroxUser);

      expect(result, isA<Left<Err, AeroxUser>>());
    });

    test('Failure: FirebaseAuthException, should return [SignInErr]', () async {
      when(() => firebaseAuth.createUserWithEmailAndPassword(
            email: aeroxUser.email,
            password: aeroxUser.password!,
          )).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

      final result = await emailAuthService.createUserWithEmail(aeroxUser: aeroxUser);

      expect(result, isA<Left<Err, AeroxUser>>());
    });
  });

  group('Sign out', () {
    test('Success case: Should return [void]', () async {
      when(() => firebaseAuth.signOut()).thenAnswer((_) async {});

      final result = await emailAuthService.signOut();

      expect(result, isA<Right<Err, void>>());
    });

    test('Failure case: Should return [Err]', () async {
      when(() => firebaseAuth.signOut()).thenThrow(Exception());

      final result = await emailAuthService.signOut();

      expect(result, isA<Left<Err, void>>());
    });
  });

  group('Reset password', () {
    final email = 'test@example.com';

    test('Success case: Should return [void]', () async {
      when(() => firebaseAuth.sendPasswordResetEmail(email: email))
          .thenAnswer((_) async {});

      final result = await emailAuthService.sendPasswordResetEmail(email: email);

      expect(result, isA<Right<Err, void>>());
    });

    test('Failure case: Should return [Err]', () async {
      when(() => firebaseAuth.sendPasswordResetEmail(email: email))
          .thenThrow(Exception());

      final result = await emailAuthService.sendPasswordResetEmail(email: email);

      expect(result, isA<Left<Err, void>>());
    });
  });
}
