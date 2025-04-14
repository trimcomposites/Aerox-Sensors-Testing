part of 'ble_storage_bloc.dart';

class BleStorageEvent {}
class OnGetSelectedRacketBleStoragePage extends BleStorageEvent{}
class OnAutoDisconnectSelectedRacketBleStoragePage extends BleStorageEvent{
  final String errorMsg;

  OnAutoDisconnectSelectedRacketBleStoragePage({required this.errorMsg});
}
class OnReadStorageDataBleStoragePage extends BleStorageEvent{
  final RacketSensor sensor;

  OnReadStorageDataBleStoragePage({required this.sensor});

}
class OnFilterBlobsByDate extends BleStorageEvent {
  final DateTime cutoff;
  OnFilterBlobsByDate(this.cutoff);
}
class OnFilterBlobsByExactDay extends BleStorageEvent {
  final DateTime date;

  OnFilterBlobsByExactDay(this.date);
}
class OnParseBlobBleStorage extends BleStorageEvent {
  final Blob blob;

  OnParseBlobBleStorage({required this.blob});
}