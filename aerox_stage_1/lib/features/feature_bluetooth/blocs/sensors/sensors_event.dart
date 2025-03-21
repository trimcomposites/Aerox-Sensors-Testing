part of 'sensors_bloc.dart';

class SensorsEvent extends Equatable {
  const SensorsEvent();

  @override
  List<Object> get props => [];
}

class OnStartScanBluetoothSensors extends SensorsEvent {
  
}
class OnStopScanBluetoothSensors extends SensorsEvent {
  
}
class UpdateSensorsList extends SensorsEvent {
  final List<RacketSensorEntity> sensors;
  UpdateSensorsList(this.sensors);
}
class RemoveDisconnectedSensor extends SensorsEvent {
  final String id;

  RemoveDisconnectedSensor({required this.id});


}