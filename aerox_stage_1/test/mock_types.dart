import 'package:aerox_stage_1/domain/use_cases/login/check_user_signed_in_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/register_user_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/reset_password_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/sign_in_user_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/sign_out_user_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/get_rackets_usecase.dart';
import 'package:aerox_stage_1/features/feature_racket/repository/remote/mock_racket_datasource.dart';
import 'package:aerox_stage_1/features/feature_racket/repository/remote/racket_repository.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/login_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginRepo extends Mock implements LoginRepository{}

class MockFirebaseUser extends Mock implements User {}

class MockSignInUserUseCase extends Mock implements SignInUserUsecase{}
class MockSignOutUserUsecase extends Mock implements SignOutUserUsecase{}
class MockRegisterUserUsecase extends Mock implements RegisterUserUsecase{}
class MockCheckUserSignedInUsecase extends Mock implements CheckUserSignedInUsecase{}
class MockResetPasswordUsecase extends Mock implements ResetPasswordUsecase{}

class MockUserCredential extends Mock implements UserCredential{}
class MockFirebaseAuth2 extends Mock implements FirebaseAuth{}
class MockGoogleSignIn extends Mock implements GoogleSignIn{}
class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount{}
class MockGoogleSignInAuthentication extends Mock implements GoogleSignInAuthentication{}
class MockGoogleAuthProvider extends Mock implements GoogleAuthProvider{}
class MockAuthCredential extends Mock implements AuthCredential{}

class MockMockRacketDataSource extends Mock implements MockRacketDatasource{}
class MockRacketRepository extends Mock implements RacketRepository{}

class MockGetRacketsUseCase extends Mock implements GetRacketsUsecase{}
