import 'package:aerox_stage_1/common/services/aerox_asset_bundle.dart';
import 'package:aerox_stage_1/common/services/injection_container.dart';
import 'package:aerox_stage_1/common/services/router.dart';
import 'package:aerox_stage_1/features/feature_3d/blocs/bloc/3d_bloc.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_blob_database/blocs/blob_database/blob_database_bloc.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_blob_database/repository/local/blobs_sqlite_db.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_rtsos_hs/blocs/rtsos_lobby/rtsos_lobby_bloc.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_ble_storage/blocs/ble_storage/ble_storage_bloc.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/blocs/selected_entity_page/selected_entity_page_bloc.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/blocs/sensors/sensors_bloc.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/ui/bluetooth_selected_racket_page.dart';
import 'package:aerox_stage_1/features/feature_racket/blocs/racket/racket_bloc.dart';
import 'package:aerox_stage_1/features/feature_home/blocs/home_screen/home_screen_bloc.dart';
import 'package:aerox_stage_1/features/feature_racket/repository/local/rackets_sqlite_db.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/feature_login/ui/login_barrel.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dependencyInjectionInitialize();
  await sl.allReady();

  
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform
  // );
    runApp(
    DefaultAssetBundle(
      bundle: AeroxAssetBundle(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: ( context )=>sl<RacketBloc>()
          ),
          BlocProvider(
            create: ( context )=>sl<HomeScreenBloc>() 
          ),
          BlocProvider(
            create: ( context )=>sl<Model3DBloc>() 
          ),
          BlocProvider(
            create: ( context )=>sl<SensorsBloc>() 
          ),
          BlocProvider(
            create: ( context )=>sl<SelectedEntityPageBloc>()  
          ),
          BlocProvider(
            create: ( context )=>sl<RtsosLobbyBloc>() 
          ),
          BlocProvider(
            create: ( context )=>sl<BleStorageBloc>() 
          ),
          BlocProvider(
            create: ( context )=>sl<BlobDatabaseBloc>() 
          ),

      ],
      child: const MyApp()),
    )
  );
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    
      final RacketsSQLiteDB db = sl();
      final BlobSQLiteDB blobDb = sl();
      //blobDb.clearParsedBlobs();
      blobDb.deleteDatabaseFile();
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