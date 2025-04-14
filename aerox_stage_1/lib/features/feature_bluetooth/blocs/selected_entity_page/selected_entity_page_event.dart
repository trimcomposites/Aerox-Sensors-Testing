part of 'selected_entity_page_bloc.dart';

class SelectedEntityPageEvent {}

class OnDisconnectSelectedRacketSelectedEntityPage extends SelectedEntityPageEvent {
  
}
class OnAutoDisconnectSelectedRacket extends SelectedEntityPageEvent {
  final String  errorMsg;

  OnAutoDisconnectSelectedRacket({required this.errorMsg});
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
class OnSetTimeStamp extends SelectedEntityPageEvent {
  final RacketSensor sensor;

  OnSetTimeStamp({required this.sensor});
}
class OnGetTimeStamp extends SelectedEntityPageEvent {
  final RacketSensor sensor;

  OnGetTimeStamp({required this.sensor});
}
class OnStartStreamRTSOS extends SelectedEntityPageEvent {
  final RacketSensor sensor;

  OnStartStreamRTSOS({required this.sensor});
}
class OnReadCharacteristicsFromSensor extends SelectedEntityPageEvent {
  final RacketSensor sensor;

  OnReadCharacteristicsFromSensor({required this.sensor});
}
class OnGetBlobPackets extends SelectedEntityPageEvent {
  final RacketSensor sensor;

  OnGetBlobPackets({required this.sensor});
}
class OnParseBlob extends SelectedEntityPageEvent {
  final Blob blob;

  OnParseBlob({required this.blob});
}
class OnEraseStorageData extends SelectedEntityPageEvent {
  final RacketSensor sensor;

  OnEraseStorageData({required this.sensor});

}
