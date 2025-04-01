import 'package:aerox_stage_1/common/services/download_file.dart';
import 'package:aerox_stage_1/domain/use_cases/ble_sensor/read_storage_data_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/ble_sensor/start_offline_rtsos_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/ble_sensor/stop_offline_rtsos_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/ble_sensor/stream_rtsos_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/connect_to_racket_sensor_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/disconnect_from_racket_sensor_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/get_selected_bluetooth_racket_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/rescan_racket_sensors_use_case.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/start_scan_bluetooth_sensors_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/stop_scan_bluetooth_sensors_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/comments/get_comments_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/comments/get_city_location_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/comments/hide_comment_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/comments/save_comment_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/check_user_signed_in_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/register_user_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/reset_password_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/sign_in_user_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/sign_out_user_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/download_racket_images_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/get_rackets_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/get_selected_racket_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/select_racket_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/unselect_racket_usecase.dart';
import 'package:aerox_stage_1/features/feature_3d/blocs/bloc/3d_bloc.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/ble_repository.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/local/ble_service.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/blocs/selected_entity_page/selected_entity_page_bloc.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/blocs/sensors/sensors_bloc.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/bluetooth_repository.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/local/bluetooth_permission_handler.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/local/bluetooth_service.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/local/racket_bluetooth_service.dart';
import 'package:aerox_stage_1/features/feature_comments/blocs/bloc/comments_bloc.dart';
import 'package:aerox_stage_1/features/feature_comments/repository/comments_repository.dart';
import 'package:aerox_stage_1/features/feature_comments/repository/local/comment_location_service.dart';
import 'package:aerox_stage_1/features/feature_comments/repository/remote/firestore_comments.dart';
import 'package:aerox_stage_1/features/feature_details/blocs/details_screen/details_screen_bloc.dart';
import 'package:aerox_stage_1/features/feature_home/blocs/home_screen/home_screen_bloc.dart';
import 'package:aerox_stage_1/features/feature_login/repository/login_repository.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/apple_auth_service.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/remote_barrel.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:aerox_stage_1/features/feature_racket/blocs/racket/racket_bloc.dart';
import 'package:aerox_stage_1/features/feature_racket/repository/local/rackets_sqlite_db.dart';
import 'package:aerox_stage_1/features/feature_racket/repository/racket_repository.dart';
import 'package:aerox_stage_1/features/feature_racket/repository/remote/remote_get_rackets.dart';
import 'package:aerox_stage_1/features/feature_select/blocs/select_screen/select_screen_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

final sl = GetIt.instance;

Future<void> dependencyInjectionInitialize() async {
  // Inicialización de Firebase
  await Firebase.initializeApp();

  // Registro de Servicios (Singletons)
  sl
    // Firebase
    ..registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance)
    ..registerLazySingleton(() => GoogleSignIn())

    // Autenticación
    ..registerLazySingleton(() => EmailAuthService(firebaseAuth: sl()))
    ..registerLazySingleton(() => GoogleAuthService(auth: sl(), googleSignIn: sl()))
    ..registerLazySingleton(() => AppleAuthService(auth: sl()))

    // Base de Datos Local
    ..registerLazySingleton(() => RacketsSQLiteDB())

    //BLuetooth
    ..registerLazySingleton(() => BluetoothPermissionHandler())
    ..registerLazySingleton(() => BluetoothCustomService( permissionHandler: sl() ))
    ..registerLazySingleton(() => RacketBluetoothService( bluetoothService: sl() ))
    ..registerLazySingleton(() => BleService())



    // Servicios Externos
    ..registerLazySingleton(() => RemoteGetRackets())
    ..registerLazySingleton(() => FirestoreComments())
    ..registerLazySingleton(() => CommentLocationService())
    ..registerLazySingleton(() => DownloadFile());




  // Registro de Repositorios
  sl
    ..registerLazySingleton(() => LoginRepository(
          firebaseAuth: sl(),
          emailAuthService: sl(),
          appleAuthService: sl(),
          googleAuthService: sl(),
        ))
    ..registerLazySingleton(() => RacketRepository(
          remoteGetRackets: sl(),
          sqLiteDB: sl(),
          downloadFile: sl()
        ))
    ..registerLazySingleton(() => CommentsRepository(
          firestoreComments: sl(),
          commentLocationService: sl(),
        ))
    ..registerLazySingleton(() => BluetoothRepository(
      bluetoothService: sl()
      ))
    ..registerLazySingleton(() => BleRepository(
       bleService: sl()
      ));

  // Registro de Casos de Uso (Use Cases)
  sl
    // Login
    ..registerLazySingleton(() => RegisterUserUseCase(loginRepo: sl()))
    ..registerLazySingleton(() => SignInUserUseCase(loginRepo: sl()))
    ..registerLazySingleton(() => SignOutUserUseCase(loginRepo: sl()))
    ..registerLazySingleton(() => CheckUserSignedInUseCase(loginRepo: sl()))
    ..registerLazySingleton(() => ResetPasswordUseCase(loginRepo: sl()))

    // Racket
    ..registerLazySingleton(() => GetRacketsUseCase(racketRepository: sl()))
    ..registerLazySingleton(() => GetSelectedRacketUseCase(racketRepository: sl()))
    ..registerLazySingleton(() => SelectRacketUseCase(racketRepository: sl()))
    ..registerLazySingleton(() => UnSelectRacketUseCase(racketRepository: sl()))
    ..registerLazySingleton(() => DownloadRacketImagesUsecase(racketRepository: sl()))

    // Comments
    ..registerLazySingleton(() => GetCommentsUsecase(commentsRepository: sl()))
    ..registerLazySingleton(() => SaveCommentUsecase(commentsRepository: sl()))
    ..registerLazySingleton(() => GetCityLocationUseCase(commentsRepository: sl()))
    ..registerLazySingleton(() => HideCommentUsecase(commentsRepository: sl()))

    //Sensores bluetooth 
    ..registerLazySingleton(() => StartScanBluetoothSensorsUsecase(bluetoothRepository: sl()))
    ..registerLazySingleton(() => ConnectToRacketSensorUsecase(bluetoothRepository: sl()))
    ..registerLazySingleton(() => DisconnectFromRacketSensorUsecase(bluetoothRepository: sl()))
    ..registerLazySingleton(() => GetSelectedBluetoothRacketUsecase(bluetoothRepository: sl()))
    ..registerLazySingleton(() => StoptScanBluetoothSensorsUsecase(bluetoothRepository: sl()))
    ..registerLazySingleton(() => ReScanRacketSensorsUseCase(bluetoothRepository: sl()))

    //ble
    ..registerLazySingleton(() => StartOfflineRTSOSUseCase( bleRepository : sl()))
    ..registerLazySingleton(() => ReadStorageDataUsecase( bleRepository : sl()))
    ..registerLazySingleton(() => StreamRTSOSUsecase( bleRepository : sl()))
    ..registerLazySingleton(() => StoptOfflineRTSOSUseCase( bleRepository : sl()));

  // Registro de Blocs
  sl
    ..registerFactory(() => UserBloc(
          signInUsecase: sl(),
          registerUseCase: sl(),
          signOutUseCase: sl(),
          checkUserSignedInUsecase: sl(),
          resetPasswordUsecase: sl(),
        ))
    ..registerFactory(() => RacketBloc(
          getRacketsUsecase: sl(),
          selectRacketUsecase: sl(),
          deselectRacketUsecase: sl(),
          getSelectedRacketUsecase: sl(),
        ))
    ..registerFactory(() => HomeScreenBloc(
          getSelectedRacketUsecase: sl(),
        ))
    ..registerFactory(() => DetailsScreenBloc(
          getSelectedRacketUsecase: sl(),
          unSelectRacketUseCase: sl(),
        ))
    ..registerFactory(() => SelectScreenBloc(
          selectRacketUseCase: sl(),
          getRacketsUseCase: sl(),
          downloadRacketImagesUsecase: sl()
        ))
    ..registerFactory(() => CommentsBloc(
          getCommentsUsecase: sl(),
          checkUserSignedInUseCase: sl(),
          getSelectedRacketUseCase: sl(),
          saveCommentUsecase: sl(),
          getCityLocationUseCase: sl(),
          hideCommentUsecase: sl(),
        ))
    ..registerFactory(() => Model3DBloc())
    ..registerFactory(() => SensorsBloc(
      connectToRacketSensorUsecase: sl(),
      startScanBluetoothSensorsUsecase: sl(),
      stopScanBluetoothSensorsUsecase: sl(),
      disconnectFromRacketSensorUsecase: sl(),
      reScanRacketSensorsUseCase: sl()
    ))
    ..registerFactory(() => SelectedEntityPageBloc(
      disconnectFromRacketSensorUsecase: sl(),
      getSelectedBluetoothRacketUsecase: sl(),
      startOfflineRTSOSUseCase: sl(),
      stopOfflineRTSOSUseCase: sl(),
      readStorageDataUsecase: sl(),
      startStreamRTSOS: sl()
    ));
}
