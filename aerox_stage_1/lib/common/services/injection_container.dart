import 'package:aerox_stage_1/domain/use_cases/register_user_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/sign_in_user_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/sign_out_user_usecase.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/login_repository.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/remote_barrel.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> dependencyInjectionInitialize() async{
  await Firebase.initializeApp();
  sl
    //bloc
    ..registerFactory( () => UserBloc(
      signInUsecase: sl(),
      registerUseCase: sl(),
      signOutUseCase: sl()
    ))
    //use cases
    ..registerLazySingleton(() => RegisterUserUsecase(loginRepo: sl()) )
    ..registerLazySingleton(() => SignInUserUsecase(loginRepo: sl()) )
    ..registerLazySingleton(() => SignOutUserUsecase(loginRepo: sl()) )

    //repository
    ..registerLazySingleton(
      () => LoginRepository(
        firebaseAuth: sl(), 
        emailAuthService: sl(), 
        googleAuthService: sl()
      )
    )

    //services

    ..registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance)
    ..registerLazySingleton(() => EmailAuthService(firebaseAuth: sl()))
    ..registerLazySingleton(() => GoogleAuthService());

}
   