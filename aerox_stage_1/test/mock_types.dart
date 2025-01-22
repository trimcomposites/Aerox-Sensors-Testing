import 'package:aerox_stage_1/domain/use_cases/login/register_user_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/sign_in_user_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/sign_out_user_usecase.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/login_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginRepo extends Mock implements LoginRepository{}
class MockFirebaseUser extends Mock implements User {}
class MockSignInUserUseCase extends Mock implements SignInUserUsecase{}
class MockSignOutUserUsecase extends Mock implements SignOutUserUsecase{}
class MockRegisterUserUsecase extends Mock implements RegisterUserUsecase{}
class MockUserCredential extends Mock implements UserCredential{}
class MockFirebaseAuth2 extends Mock implements FirebaseAuth{}