import 'package:aerox_stage_1/domain/models/aerox_user.dart';
import 'package:aerox_stage_1/domain/use_cases/login/check_user_signed_in_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mock_types.dart';

late FirebaseAuth firebaseAuth;
late CheckUserSignedInUsecase checkUserSignedInUsecase;
late User mockUser;
final user = AeroxUser(name: 'name', email: 'email');
void main() {
  setUp((){
    firebaseAuth = MockFirebaseAuth2();
    mockUser = MockFirebaseUser();
    checkUserSignedInUsecase = CheckUserSignedInUsecase(firebaseAuth: firebaseAuth);
  });
  group('check user signed in usecase ...', () {
    test('user is already signed in, return [ User ]', ()async {
    () async{
      when(
      () => firebaseAuth.currentUser
    ).thenReturn( mockUser );
    final result = checkUserSignedInUsecase();
    expect(result, equals(user));
    };
  });
    test('user is not already signed in, return [ null ]', ()async {
    () async{
      when(
      () => firebaseAuth.currentUser
    ).thenReturn( null );
    final result = checkUserSignedInUsecase();
    expect(result, equals(user));
    };
  });
});
  }