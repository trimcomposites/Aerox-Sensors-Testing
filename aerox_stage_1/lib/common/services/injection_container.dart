import 'package:aerox_stage_1/domain/use_cases/login/check_user_signed_in_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/register_user_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/reset_password_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/sign_in_user_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/sign_out_user_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/unselect_racket_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/get_rackets_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/get_selected_racket_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/select_racket_usecase.dart';
import 'package:aerox_stage_1/features/feature/3d/blocs/bloc/3d_bloc.dart';
import 'package:aerox_stage_1/features/feature_racket/blocs/racket/racket_bloc.dart';
import 'package:aerox_stage_1/features/feature_racket/feature_details/blocs/details_screen/details_screen_bloc.dart';
import 'package:aerox_stage_1/features/feature_racket/feature_select/blocs/select_screen/select_screen_bloc.dart';
import 'package:aerox_stage_1/features/feature_racket/repository/domain/sqlite_db.dart';
import 'package:aerox_stage_1/features/feature_racket/repository/racket_repository.dart';
import 'package:aerox_stage_1/features/feature_home/blocs/home_screen/home_screen_bloc.dart';
import 'package:aerox_stage_1/features/feature_login/repository/login_repository.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/remote_barrel.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:aerox_stage_1/features/feature_racket/repository/remote/remote_get_rackets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

final sl = GetIt.instance;

Future<void> dependencyInjectionInitialize() async{
  await Firebase.initializeApp();
  sl
    //bloc
    ..registerFactory( () => UserBloc(
      signInUsecase: sl(),
      registerUseCase: sl(),
      signOutUseCase: sl(),
      checkUserSignedInUsecase: sl(),
      resetPasswordUsecase: sl()
    ))
    ..registerFactory(() => RacketBloc(
      getRacketsUsecase: sl(),
      selectRacketUsecase: sl(),
      deselectRacketUsecase: sl(),
      getSelectedRacketUsecase: sl()
    ))
    ..registerFactory(() => HomeScreenBloc(
      getSelectedRacketUsecase: sl()
    ))
    ..registerFactory(() => DetailsScreenBloc(
      getSelectedRacketUsecase: sl(),
      unSelectRacketUseCase: sl()
    ))
    ..registerFactory(() => SelectScreenBloc(
      selectRacketUseCase: sl(),
      getRacketsUseCase: sl()
    ))
    ..registerFactory(() => Model3DBloc(
    ))
    //use cases//

    //login
    ..registerLazySingleton(() => RegisterUserUseCase(loginRepo: sl()) )
    ..registerLazySingleton(() => SignInUserUseCase(loginRepo: sl()) )
    ..registerLazySingleton(() => SignOutUserUseCase(loginRepo: sl()) )
    ..registerLazySingleton(() => CheckUserSignedInUseCase(loginRepo: sl()) )
    ..registerLazySingleton(() => ResetPasswordUseCase( loginRepo: sl() ) )

    //racket
    ..registerLazySingleton(() =>GetRacketsUseCase(racketRepository: sl()) )
    ..registerLazySingleton(() =>GetSelectedRacketUseCase(racketRepository: sl()) )
    ..registerLazySingleton(() =>SelectRacketUseCase(racketRepository: sl()) )
    ..registerLazySingleton(() =>UnSelectRacketUseCase(racketRepository: sl()) )

    //repository
    ..registerLazySingleton(
      () => LoginRepository(
        firebaseAuth: sl(), 
        emailAuthService: sl(), 
        googleAuthService: sl()
      )
    )
    ..registerLazySingleton(
      () => RacketRepository(
        remoteGetRackets: sl(),
        sqLiteDB: sl()
      )
    )

    //services//

    //sqlite
    ..registerLazySingleton(() => SQLiteDB())

    //login
    ..registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance)
    ..registerLazySingleton(() => EmailAuthService(firebaseAuth: sl()))
    ..registerLazySingleton(() => GoogleAuthService(
      auth: sl(),
      googleSignIn: sl()
    ))
    ..registerLazySingleton(() => GoogleSignIn())

    //racket
    ..registerLazySingleton(() => RemoteGetRackets(
    )); 

}
   