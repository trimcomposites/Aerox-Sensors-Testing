import 'package:aerox_stage_1/common/services/download_file.dart';
import 'package:aerox_stage_1/domain/use_cases/comments/get_city_location_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/comments/get_comments_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/comments/hide_comment_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/comments/save_comment_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/check_user_signed_in_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/register_user_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/reset_password_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/sign_in_user_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/sign_out_user_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/get_rackets_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/get_selected_racket_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/select_racket_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/unselect_racket_usecase.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/bluetooth_repository.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/local/bluetooth_permission_handler.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/local/bluetooth_service.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/local/racket_bluetooth_service.dart';
import 'package:aerox_stage_1/features/feature_comments/repository/comments_repository.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/apple_auth_service.dart';
import 'package:aerox_stage_1/features/feature_racket/repository/local/rackets_sqlite_db.dart';
import 'package:aerox_stage_1/features/feature_racket/repository/racket_repository.dart';
import 'package:aerox_stage_1/features/feature_login/repository/login_repository.dart';
import 'package:aerox_stage_1/features/feature_racket/repository/remote/remote_get_rackets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler/permission_handler.dart';

class MockLoginRepo extends Mock implements LoginRepository{}

class MockFirebaseUser extends Mock implements User {}

class MockSignInUserUseCase extends Mock implements SignInUserUseCase{}
class MockSignOutUserUsecase extends Mock implements SignOutUserUseCase{}
class MockRegisterUserUsecase extends Mock implements RegisterUserUseCase{}
class MockCheckUserSignedInUsecase extends Mock implements CheckUserSignedInUseCase{}
class MockResetPasswordUsecase extends Mock implements ResetPasswordUseCase{}

class MockUserCredential extends Mock implements UserCredential{}
class MockFirebaseAuth2 extends Mock implements FirebaseAuth{}
class MockGoogleSignIn extends Mock implements GoogleSignIn{}
class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount{}
class MockGoogleSignInAuthentication extends Mock implements GoogleSignInAuthentication{}
class MockGoogleAuthProvider extends Mock implements GoogleAuthProvider{}
class MockAppleAuthService extends Mock implements AppleAuthService{}
class MockAppleAuthProvider extends Mock implements AppleAuthProvider {}
class MockBluetoothRepository extends Mock implements BluetoothRepository {}

class MockAuthCredential extends Mock implements AuthCredential{}
class MockDownloadFile extends Mock implements DownloadFile{}

class MockRacketRepository extends Mock implements RacketRepository{}
class MockCommentsRepository extends Mock implements CommentsRepository{}
class MockSQLiteDB extends Mock implements RacketsSQLiteDB{}
class MockRemoteGetRackets extends Mock implements RemoteGetRackets{}

class MockGetRacketsUseCase extends Mock implements GetRacketsUseCase{}
class MockGetSelectedRacketUseCase extends Mock implements GetSelectedRacketUseCase{}
class MockUnSelectRacketUseCase extends Mock implements UnSelectRacketUseCase{}
class MockSelectRacketUseCase extends Mock implements SelectRacketUseCase{}

class MockBluetoothDevice extends Mock implements BluetoothDevice{}
class MockGetCommentsUsecase extends Mock implements GetCommentsUsecase {}
class MockCheckUserSignedInUseCase extends Mock implements CheckUserSignedInUseCase {}
class MockSaveCommentUsecase extends Mock implements SaveCommentUsecase {}
class MockHideCommentUsecase extends Mock implements HideCommentUsecase {}
class MockGetCityLocationUseCase extends Mock implements GetCityLocationUseCase {}

class MockRacketBluetoothService extends Mock implements RacketBluetoothService {}
class MockBluetoothCustomService extends Mock implements BluetoothCustomService {}
class MockBluetoothPermissionHandler extends Mock implements BluetoothPermissionHandler {}
class MockFlutterBluePlus extends Mock implements FlutterBluePlus {}
