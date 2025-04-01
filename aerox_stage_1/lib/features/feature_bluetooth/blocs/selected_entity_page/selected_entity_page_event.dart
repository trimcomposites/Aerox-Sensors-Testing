part of 'selected_entity_page_bloc.dart';

class SelectedEntityPageEvent {}

class OnDisconnectSelectedRacketSelectedEntityPage extends SelectedEntityPageEvent {
  
}
class OnShowConnectionError extends SelectedEntityPageEvent {
  final String errorMsg;

  OnShowConnectionError({required this.errorMsg});
}
class OnGetSelectedRacketSelectedEntityPage extends SelectedEntityPageEvent {
  
}
class OnStartHSBlob extends SelectedEntityPageEvent {
  final RacketSensor sensor;

  OnStartHSBlob({required this.sensor});
}
class OnStopHSBlob extends SelectedEntityPageEvent {
  final RacketSensor sensor;

  OnStopHSBlob({required this.sensor});
}
class OnReadStorageData extends SelectedEntityPageEvent {
  final RacketSensor sensor;

  OnReadStorageData({required this.sensor});
}
class OnStartStreamRTSOS extends SelectedEntityPageEvent {
  final RacketSensor sensor;

  OnStartStreamRTSOS({required this.sensor});
}
class OnReadCharacteristicsFromSensor extends SelectedEntityPageEvent {
  final RacketSensor sensor;

  OnReadCharacteristicsFromSensor({required this.sensor});
}
