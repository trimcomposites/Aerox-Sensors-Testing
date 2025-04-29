import 'package:aerox_stage_1/common/services/download_file.dart';
import 'package:aerox_stage_1/domain/use_cases/ble_sensor/erase_storage_data_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/ble_sensor/get_num_blobs_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/ble_sensor/get_sensor_timestamp_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/ble_sensor/parse_blob_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/ble_sensor/read_storage_data_from_sensor_list.dart';
import 'package:aerox_stage_1/domain/use_cases/ble_sensor/read_storage_data_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/ble_sensor/set_sensor_timestamp.dart';
import 'package:aerox_stage_1/domain/use_cases/ble_sensor/start_offline_rtsos_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/ble_sensor/stop_offline_rtsos_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/ble_sensor/stream_rtsos_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/blob_database/export_to_csv_blob_list_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/blob_database/get_all_blobs_from_db_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/connect_to_racket_sensor_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/disconnect_from_racket_sensor_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/get_selected_bluetooth_racket_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/rescan_racket_sensors_use_case.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/start_scan_bluetooth_sensors_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/stop_scan_bluetooth_sensors_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/download_racket_images_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/get_rackets_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/get_selected_racket_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/select_racket_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/unselect_racket_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/storage/upload_blobs_to_storage_usecase.dart';
import 'package:aerox_stage_1/features/feature_3d/blocs/bloc/3d_bloc.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_blob_database/blocs/blob_database/blob_database_bloc.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_blob_database/repository/blob_repository.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_rtsos_hs/blocs/rtsos_lobby/rtsos_lobby_bloc.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/ble_repository.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/blob_data_parser.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/local/ble_service.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/local/to_csv_blob.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/storage_service_controller.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_ble_storage/blocs/ble_storage/ble_storage_bloc.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/blocs/selected_entity_page/selected_entity_page_bloc.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/blocs/sensors/sensors_bloc.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/bluetooth_repository.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/local/bluetooth_permission_handler.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/local/bluetooth_service.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/local/racket_bluetooth_service.dart';
import 'package:aerox_stage_1/features/feature_home/blocs/home_screen/home_screen_bloc.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:aerox_stage_1/features/feature_racket/blocs/racket/racket_bloc.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_blob_database/repository/local/blobs_sqlite_db.dart';
import 'package:aerox_stage_1/features/feature_racket/repository/local/rackets_sqlite_db.dart';
import 'package:aerox_stage_1/features/feature_racket/repository/racket_repository.dart';
import 'package:aerox_stage_1/features/feature_racket/repository/remote/remote_get_rackets.dart';
import 'package:aerox_stage_1/features/feature_storage/repository/remote/storage_service.dart';
import 'package:aerox_stage_1/features/feature_storage/repository/upload_repository.dart';
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
    // Base de Datos Local
    ..registerLazySingleton(() => RacketsSQLiteDB())
    ..registerLazySingleton(() => BlobSQLiteDB())

    //BLuetooth
    ..registerLazySingleton(() => BluetoothPermissionHandler())
    ..registerLazySingleton(() => BluetoothCustomService( permissionHandler: sl() ))
    ..registerLazySingleton(() => RacketBluetoothService( bluetoothService: sl() ))
    ..registerLazySingleton(() => BleService())
    ..registerLazySingleton(() => BlobDataParser())
    ..registerLazySingleton(() => ToCsvBlob())

    //storage
    ..registerLazySingleton(() => StorageService())



    // Servicios Externos
    ..registerLazySingleton(() => RemoteGetRackets())
    ..registerLazySingleton(() => DownloadFile());




  // Registro de Repositorios
  sl
    ..registerLazySingleton(() => RacketRepository(
          remoteGetRackets: sl(),
          sqLiteDB: sl(),
          downloadFile: sl()
        ))
    ..registerLazySingleton(() => BluetoothRepository(
      bluetoothService: sl()
      ))
    ..registerLazySingleton(() => StorageServiceController(
        bleService: sl()
      ))
    ..registerLazySingleton(() => BleRepository(
       bleService: sl(),
       storageServiceController: sl(),
       blobDataParser: sl(),
       toCsvBlob: sl(), 
       blobSqliteDB: sl()
      ))
    ..registerLazySingleton(() => UploadRepository(
        storageUploadService: sl()
      ))
    ..registerLazySingleton(() => BlobRepository(
      blobSQLiteDB: sl(),
      toCsvBlob: sl()
      ));

  // Registro de Casos de Uso (Use Cases)
  sl
    // Racket
    ..registerLazySingleton(() => GetRacketsUseCase(racketRepository: sl()))
    ..registerLazySingleton(() => GetSelectedRacketUseCase(racketRepository: sl()))
    ..registerLazySingleton(() => SelectRacketUseCase(racketRepository: sl()))
    ..registerLazySingleton(() => UnSelectRacketUseCase(racketRepository: sl()))
    ..registerLazySingleton(() => DownloadRacketImagesUsecase(racketRepository: sl()))

    //Sensores bluetooth 
    ..registerLazySingleton(() => StartScanBluetoothSensorsUsecase(bluetoothRepository: sl()))
    ..registerLazySingleton(() => ConnectToRacketSensorUsecase(bluetoothRepository: sl()))
    ..registerLazySingleton(() => DisconnectFromRacketSensorUsecase(bluetoothRepository: sl()))
    ..registerLazySingleton(() => GetSelectedBluetoothRacketUsecase(bluetoothRepository: sl()))
    ..registerLazySingleton(() => StoptScanBluetoothSensorsUsecase(bluetoothRepository: sl()))
    ..registerLazySingleton(() => ReScanRacketSensorsUseCase(bluetoothRepository: sl()))
    ..registerLazySingleton(() => EraseStorageDataUsecase(bleRepository: sl()))
    ..registerLazySingleton(() => GetAllBlobsFromDbUsecase(blobRepository: sl()))
    ..registerLazySingleton(() => ExportToCsvBlobListUsecase(blobRepository: sl()))

    //storage 
    ..registerLazySingleton(() => UploadBlobsToStorageUsecase(uploadRepository: sl()))
    ..registerLazySingleton(() => ReadStorageDataUsecase( bleRepository : sl(), blobSQLiteDB: sl()))
    ..registerLazySingleton(() => ReadStorageDataFromSensorListUsecase( bleRepository : sl(), blobSQLiteDB: sl()))
    ..registerLazySingleton(() => GetNumBlobsUsecase( bleRepository : sl()))

    //ble
    ..registerLazySingleton(() => StartOfflineRTSOSUseCase( bleRepository : sl()))
    ..registerLazySingleton(() => StreamRTSOSUsecase( bleRepository : sl())) 
    ..registerLazySingleton(() => ParseBlobUsecase( bleRepository : sl())) 
    ..registerLazySingleton(() => SetSensorTimestampUseCase( bleRepository : sl())) 
    ..registerLazySingleton(() => GetSensorTimestampUseCase( bleRepository : sl())) 
    ..registerLazySingleton(() => StoptOfflineRTSOSUseCase( bleRepository : sl()));

  // Registro de Blocs
  sl
    ..registerFactory(() => RacketBloc(
          getRacketsUsecase: sl(),
          selectRacketUsecase: sl(),
          deselectRacketUsecase: sl(),
          getSelectedRacketUsecase: sl(),
        ))
    ..registerFactory(() => HomeScreenBloc(
          getSelectedRacketUsecase: sl(),
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
      startStreamRTSOS: sl(),
      parseBlobUsecase: sl(),
      eraseStorageDataUsecase: sl(),
      setTimestampUseCase: sl(),
      getTimestampUseCase: sl()
    ))
    ..registerFactory(() => RtsosLobbyBloc(
      getSelectedBluetoothRacketUsecase: sl(),
      startOfflineRTSOSUseCase: sl(),
      disconnectFromRacketSensorUsecase: sl(),
      getNumBlobsUsecase: sl()
    ))
    ..registerFactory(() => BleStorageBloc(
      getSelectedBluetoothRacketUsecase: sl(),
      disconnectFromRacketSensorUsecase: sl(),
      readStorageDataUsecase: sl(),
      parseBlobUsecase: sl(),
      readStorageDataFromSensorListUsecase: sl()
    ))
    ..registerFactory(() => BlobDatabaseBloc(
      getAllBlobsFromDbUsecase: sl(),
      exportToCsvBlobListUsecase: sl(),
      uploadBlobsToStorageUsecase: sl(),
    ));
}
