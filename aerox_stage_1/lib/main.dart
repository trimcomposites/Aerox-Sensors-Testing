import 'package:aerox_stage_1/common/services/injection_container.dart';
import 'package:aerox_stage_1/domain/use_cases/register_user_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/sign_in_user_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/sign_out_user_usecase.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/firebase_options.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/login_repository.dart';
import 'package:aerox_stage_1/features/feature_splash/ui/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/feature_login/ui/login_barrel.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  dependencyInjectionInitialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
    runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: ( context )=>sl<UserBloc>()..add( OnCheckUserIsSignedIn() ) )
    ],
    child: const MyApp())
  );
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aerox',
      home: SplashScreen()
    );
  }
}