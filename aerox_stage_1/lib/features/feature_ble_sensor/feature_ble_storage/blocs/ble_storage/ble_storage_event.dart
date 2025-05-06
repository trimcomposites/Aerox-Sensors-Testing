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
class OnReadStorageDataFromSensorListBleStoragePage extends BleStorageEvent{
  final List<RacketSensor> sensors;

  OnReadStorageDataFromSensorListBleStoragePage({required this.sensors});

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
class OnUpdateGlobalRead extends BleStorageEvent {
  final int read;

  OnUpdateGlobalRead(this.read);
}
class OnUpdateGlobalTotal extends BleStorageEvent {
  final int total;

  OnUpdateGlobalTotal(this.total);
}
class OnReadStorageDataForegroundBleStoragePage extends BleStorageEvent {
  final List<RacketSensor> sensors;

  OnReadStorageDataForegroundBleStoragePage({required this.sensors});
}
