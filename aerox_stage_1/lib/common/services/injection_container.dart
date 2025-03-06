import 'package:aerox_stage_1/common/services/download_file.dart';
import 'package:aerox_stage_1/domain/use_cases/comments/get_comments_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/comments/get_city_location_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/comments/hide_comment_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/comments/save_comment_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/check_user_signed_in_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/register_user_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/reset_password_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/sign_in_user_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/sign_out_user_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/download_racket_models_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/get_rackets_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/get_selected_racket_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/select_racket_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/unselect_racket_usecase.dart';
import 'package:aerox_stage_1/features/feature_3d/blocs/bloc/3d_bloc.dart';
import 'package:aerox_stage_1/features/feature_comments/blocs/bloc/comments_bloc.dart';
import 'package:aerox_stage_1/features/feature_comments/repository/comments_repository.dart';
import 'package:aerox_stage_1/features/feature_comments/repository/local/comment_location_service.dart';
import 'package:aerox_stage_1/features/feature_comments/repository/remote/firestore_comments.dart';
import 'package:aerox_stage_1/features/feature_details/blocs/details_screen/details_screen_bloc.dart';
import 'package:aerox_stage_1/features/feature_home/blocs/home_screen/home_screen_bloc.dart';
import 'package:aerox_stage_1/features/feature_login/repository/login_repository.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/remote_barrel.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:aerox_stage_1/features/feature_racket/blocs/racket/racket_bloc.dart';
import 'package:aerox_stage_1/features/feature_racket/repository/local/rackets_sqlite_db.dart';
import 'package:aerox_stage_1/features/feature_racket/repository/racket_repository.dart';
import 'package:aerox_stage_1/features/feature_racket/repository/remote/remote_get_rackets.dart';
import 'package:aerox_stage_1/features/feature_select/blocs/select_screen/select_screen_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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

    // Base de Datos Local
    ..registerLazySingleton(() => RacketsSQLiteDB())

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
    ..registerLazySingleton(() => DownloadRacketModelsUsecase(racketRepository: sl()))

    // Comments
    ..registerLazySingleton(() => GetCommentsUsecase(commentsRepository: sl()))
    ..registerLazySingleton(() => SaveCommentUsecase(commentsRepository: sl()))
    ..registerLazySingleton(() => GetCityLocationUseCase(commentsRepository: sl()))
    ..registerLazySingleton(() => HideCommentUsecase(commentsRepository: sl()));

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
          downloadRacketModelsUsecase: sl()
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
          downloadRacketModelsUsecase: sl()
        ))
    ..registerFactory(() => CommentsBloc(
          getCommentsUsecase: sl(),
          checkUserSignedInUseCase: sl(),
          getSelectedRacketUseCase: sl(),
          saveCommentUsecase: sl(),
          getCityLocationUseCase: sl(),
          hideCommentUsecase: sl(),
        ))
    ..registerFactory(() => Model3DBloc());
}
