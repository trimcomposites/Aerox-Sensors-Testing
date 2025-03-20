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
  final List<RacketSensor> sensors;
  UpdateSensorsList(this.sensors);
}
