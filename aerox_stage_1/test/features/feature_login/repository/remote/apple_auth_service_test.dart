import 'package:aerox_stage_1/common/utils/either_catch.dart';
import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/common/utils/error/err/sign_in_err.dart';
import 'package:aerox_stage_1/domain/models/aerox_user.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/apple_auth_service.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/firebase_user_extension.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../mock_types.dart';

class FakeAppleAuthProvider extends Fake implements AppleAuthProvider {}

late AppleAuthService appleAuthService;
late FirebaseAuth firebaseAuth;

void main() {
  setUpAll(() {
    // Registrar fallback para evitar errores con mocktail
    registerFallbackValue(FakeAppleAuthProvider());
  });

  setUp(() {
    firebaseAuth = MockFirebaseAuth2();
    appleAuthService = AppleAuthService(auth: firebaseAuth);
  });

  final aeroxUser = AeroxUser(name: 'name', email: 'email', id: '1');
  final userCredential = MockUserCredential();
  final user = MockFirebaseUser();
  final appleProvider = AppleAuthProvider()
    ..addScope('email')
    ..addScope('name');

  group('sign in with Apple method', () {
    test('success Apple sign in, should return [User]', () async {
      when(() => firebaseAuth.signInWithProvider(any()))
          .thenAnswer((_) async => userCredential);
      when(() => userCredential.user).thenReturn(user);
      when(() => user.uid).thenReturn('1');
      when(() => user.displayName).thenReturn('name');
      when(() => user.email).thenReturn('email');

      final result = await appleAuthService.signInWithApple();

      // Assert
      expect(result, equals(Right<SignInErr, AeroxUser>(aeroxUser)));
      verify(() => firebaseAuth.signInWithProvider(any())).called(1);
      verifyNoMoreInteractions(firebaseAuth);
    });

    test('when User is null => failure Apple sign in, should return [SignInErr]', () async {
      when(() => firebaseAuth.signInWithProvider(any()))
          .thenAnswer((_) async => userCredential);
      when(() => userCredential.user).thenReturn(null);

      final result = await appleAuthService.signInWithApple();

      // Assert
      expect(result, isA<Left<Err, AeroxUser>>());
      verify(() => firebaseAuth.signInWithProvider(any())).called(1);
      verifyNoMoreInteractions(firebaseAuth);
    });

    test('when throws [UnhandledException] => failure Apple sign in, should return [SignInErr]', () async {
      when(() => firebaseAuth.signInWithProvider(any())).thenThrow(Exception());

      final result = await appleAuthService.signInWithApple();

      // Assert
      expect(result, isA<Left<Err, AeroxUser>>());
      verify(() => firebaseAuth.signInWithProvider(any())).called(1);
      verifyNoMoreInteractions(firebaseAuth);
    });
  });

  group('Apple sign out', () {
    test('sign out success, should return [void]', () async {
      when(() => firebaseAuth.signOut()).thenAnswer((_) async => Future.value());

      final result = await appleAuthService.signOut();

      // Assert
      expect(result, equals(Right<Err, void>(null))); 
      verify(() => firebaseAuth.signOut()).called(1);
      verifyNoMoreInteractions(firebaseAuth);
    });

    test('when sign out throws error, should return [SignInErr]', () async {
      when(() => firebaseAuth.signOut()).thenThrow(Exception('Error signing out'));

      final result = await appleAuthService.signOut();

      // Assert
      expect(result, isA<Left<Err, void>>());
      verify(() => firebaseAuth.signOut()).called(1);
      verifyNoMoreInteractions(firebaseAuth);
    });
  });
}
