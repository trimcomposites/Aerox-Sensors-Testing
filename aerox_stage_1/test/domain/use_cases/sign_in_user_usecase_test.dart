import 'package:aerox_stage_1/domain/use_cases/sign_in_user_usecase.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/login_repository.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/remote_barrel.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginRepo extends Mock implements LoginRepository{}
class MockFirebaseUser extends Mock implements User {}


  late SignInUserUsecase usecase;
  late LoginRepository repository;
  late MockFirebaseUser mockUser;

void main() {

  setUp((){
    repository = MockLoginRepo();
    usecase = SignInUserUsecase(loginRepo: repository);
    mockUser = MockFirebaseUser();
  });

  final params = SignInUserUsecaseParams.empty();
  test(' sign in user use case  should return User',  () async{

    //arrage

    when(() async => repository.signInUser(
      signInType: EmailSignInType.email,
      userData: UserData(name: 'name', email: 'email', password: 'password')
      )).thenAnswer((_) async => Right(mockUser));

    //act

    final result = await usecase( params );

    //assert
    expect(result, equals(  Right<dynamic, User>( mockUser ) ));
    verify(() => repository.signInUser(
      signInType: params.signInType, 
      userData: UserData(
        name: params.userData!.name, 
        email: params.userData!.email, 
        password: params.userData!.password
    ) )).called(1);
    verifyNoMoreInteractions( repository );

  });

  // testWidgets('sign in user usecase ...', (tester) async {
  //   // TODO: Implement test
  // });
}