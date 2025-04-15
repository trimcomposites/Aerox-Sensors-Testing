import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/domain/models/blob.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor_entity.dart';
import 'package:aerox_stage_1/domain/use_cases/ble_sensor/parse_blob_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/ble_sensor/read_storage_data_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/disconnect_from_racket_sensor_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/get_selected_bluetooth_racket_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:meta/meta.dart';

part 'ble_storage_event.dart';
part 'ble_storage_state.dart';

class BleStorageBloc extends Bloc<BleStorageEvent, BleStorageState> {
  final GetSelectedBluetoothRacketUsecase getSelectedBluetoothRacketUsecase;
  final DisconnectFromRacketSensorUsecase disconnectFromRacketSensorUsecase;
  final ReadStorageDataUsecase readStorageDataUsecase;
  final ParseBlobUsecase parseBlobUsecase;
  BleStorageBloc({
    required this.getSelectedBluetoothRacketUsecase,
    required this.disconnectFromRacketSensorUsecase,
    required this.readStorageDataUsecase,
    required this.parseBlobUsecase
  }) : super(BleStorageState( uiState: UIState.idle() )) {
    on<OnGetSelectedRacketBleStoragePage>((event, emit) async {
      emit(state.copyWith(uiState: UIState.loading()));
      await getSelectedBluetoothRacketUsecase.call().then((either) {
        either.fold(
          (failure) {
            emit(state.copyWith(uiState: UIState.error(failure.errMsg), selectedRacketEntity: null));
          },
          (r) {
            emit(state.copyWith(selectedRacketEntity: r, uiState: UIState.idle()));
            monitorSelectedRacketConnection();
          },
        );
      });
    });
    on<OnAutoDisconnectSelectedRacketBleStoragePage>((event, emit) async {
      final selectedRacket = state.selectedRacketEntity;
      if (selectedRacket != null) {
        await disconnectFromRacketSensorUsecase.call(selectedRacket);
      }

      emit(state.copyWith(
        selectedRacketEntity: null,
        uiState: UIState.error(event.errorMsg),
      ));
    });
    on<OnReadStorageDataBleStoragePage>((event, emit) async {
      await readStorageDataUsecase.call(event.sensor).then((either) {
        either.fold(
          (l) => emit(state.copyWith(uiState: UIState.error(l.errMsg))),
          (r) => emit(state.copyWith(blobs: r)),
        );
      });
    });
   on<OnFilterBlobsByDate>((event, emit) {
      final filtered = state.blobs.where((b) => b.createdAt != null && b.createdAt!.isAfter(event.cutoff)).toList();
      emit(state.copyWith(filteredBlobs: filtered));
    });
    
  on<OnFilterBlobsByExactDay>((event, emit) {
  final selectedDay = DateTime(event.date.year, event.date.month, event.date.day);

  final filtered = state.blobs.where((blob) {
    if (blob.createdAt == null) return false;
    final blobDate = DateTime(blob.createdAt!.year, blob.createdAt!.month, blob.createdAt!.day);
    return blobDate == selectedDay;
  }).toList();

  emit(state.copyWith(filteredBlobs: filtered));
});
    on<OnParseBlobBleStorage>((event, emit) async {
      await parseBlobUsecase.call(event.blob).then((either) {
        either.fold(
          (l) => emit(state.copyWith(uiState: UIState.error(l.errMsg))),
          (r) {
            final List<List<Map<String, dynamic>>> newParsedBlobs =  [ ...state.parsedBlobs, r ];
            emit( state.copyWith( parsedBlobs: newParsedBlobs ) );
            print( state.parsedBlobs );
          },
        );
      });
    });

  }
  
   void monitorSelectedRacketConnection() {
    state.selectedRacketEntity?.sensors.forEach((sensor) {
      sensor.device.connectionState.listen((connectionState) {
        if (connectionState == BluetoothConnectionState.disconnected) {
          add(OnAutoDisconnectSelectedRacketBleStoragePage(
            errorMsg: 'Se ha perdido la conexión con los sensores. Reintenta la conexión.',
          ));
        }
      });
    });
  }
}
