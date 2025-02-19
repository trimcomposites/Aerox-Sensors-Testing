import 'package:aerox_stage_1/common/services/injection_container.dart';
import 'package:aerox_stage_1/features/feature_racket/feature_details/blocs/details_screen/details_screen_bloc.dart';
import 'package:aerox_stage_1/features/feature_racket/blocs/racket/racket_bloc.dart';
import 'package:aerox_stage_1/features/feature_home/blocs/home_screen/home_screen_bloc.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/firebase_options.dart';
import 'package:aerox_stage_1/features/feature_racket/repository/domain/sqlite_db.dart';
import 'package:aerox_stage_1/features/feature_splash/ui/splash_screen.dart';
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
          create: ( context )=>sl<UserBloc>()..add( OnCheckUserIsSignedIn() ) 
        ),
        BlocProvider(
          create: ( context )=>sl<RacketBloc>()..add( OnGetRackets() ) 
        ),
        BlocProvider(
          create: ( context )=>sl<DetailsScreenBloc>() 
        ),
        BlocProvider(
          create: ( context )=>sl<HomeScreenBloc>() 
        ),
    ],
    child: const MyApp())
  );
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
      //final SQLiteDB db = sl();
      //db.clearDatabase();
    SQLiteDB sqLiteDB  =sl();
    final racketBloc = BlocProvider.of<RacketBloc>(context)..add( OnGetRackets() )..add( OnGetSelectedRacket() ) ;
    return MaterialApp(
      title: 'Aerox',
      home: SplashScreen()
    );
  }
}