part of 'sensors_bloc.dart';

class SensorsEvent extends Equatable {
  const SensorsEvent();

  @override
  List<Object> get props => [];
}

class OnStartScanBluetoothSensors extends SensorsEvent {
  
}
class OnReScanBluetoothSensors extends SensorsEvent {
  
}
class OnStopScanBluetoothSensors extends SensorsEvent {
  
}
class OnDisconnectSelectedRacket extends SensorsEvent {
  
}
class OnConnectRacketSensorEntity extends SensorsEvent {
  final String id;

  OnConnectRacketSensorEntity({required this.id});
}
class OnUpdateSensorsList extends SensorsEvent {
  final List<RacketSensorEntity> sensors;
  OnUpdateSensorsList(this.sensors);
}
