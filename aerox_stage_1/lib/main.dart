import 'package:aerox_stage_1/common/services/injection_container.dart';
import 'package:aerox_stage_1/common/services/router.dart';
import 'package:aerox_stage_1/features/feature/3d/blocs/bloc/3d_bloc.dart';
import 'package:aerox_stage_1/features/feature_comments/blocs/bloc/comments_bloc.dart';
import 'package:aerox_stage_1/features/feature_details/blocs/details_screen/details_screen_bloc.dart';
import 'package:aerox_stage_1/features/feature_racket/blocs/racket/racket_bloc.dart';
import 'package:aerox_stage_1/features/feature_home/blocs/home_screen/home_screen_bloc.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/firebase_options.dart';
import 'package:aerox_stage_1/features/feature/feature_select/blocs/select_screen/select_screen_bloc.dart';
import 'package:aerox_stage_1/features/feature_racket/repository/local/rackets_sqlite_db.dart';
import 'package:aerox_stage_1/features/feature_splash/ui/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/feature_login/ui/login_barrel.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dependencyInjectionInitialize();
  await sl.allReady();
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
          create: ( context )=>sl<RacketBloc>()
        ),
        BlocProvider(
          create: ( context )=>sl<DetailsScreenBloc>() 
        ),
        BlocProvider(
          create: ( context )=>sl<HomeScreenBloc>() 
        ),
        BlocProvider(
          create: ( context )=>sl<SelectScreenBloc>() 
        ),
        BlocProvider(          create: ( context )=>sl<CommentsBloc>() 
        ),
        BlocProvider(
          create: ( context )=>sl<Model3DBloc>() 
        ),
    ],
    child: const MyApp())
  );
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
      //final RacketsSQLiteDB db = sl();
      //db.checkAndDeleteDB();
      //db.clearDatabase();
      //db.checkAndDeleteDB();

    //final racketBloc = BlocProvider.of<RacketBloc>(context)..add( OnGetRackets() )..add( OnGetSelectedRacket() ) ;
    return MaterialApp(
      title: 'Aerox',
      routes: appRoutes,
      initialRoute: '/splash',
    );
  }
}