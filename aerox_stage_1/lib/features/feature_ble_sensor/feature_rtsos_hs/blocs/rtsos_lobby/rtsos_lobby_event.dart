part of 'rtsos_lobby_bloc.dart';

@immutable
sealed class RtsosLobbyEvent {}

class OnHitTypeValueChanged extends RtsosLobbyEvent {
  final String newValue;
  OnHitTypeValueChanged(this.newValue);
}
class OnRtsosDurationChanged extends RtsosLobbyEvent {
  final int newValue;
  OnRtsosDurationChanged(this.newValue);
}
class OnGetSelectedRacketSensorEntityLobby extends RtsosLobbyEvent {

  OnGetSelectedRacketSensorEntityLobby();
}
class OnStartHSBlobOnLobby extends RtsosLobbyEvent {
  final int duration;
  final SampleRate sampleRate;

  OnStartHSBlobOnLobby({required this.duration, required this.sampleRate});
}
class OnAutoDisconnectSelectedRacketLobby extends RtsosLobbyEvent {
  final String  errorMsg;

  OnAutoDisconnectSelectedRacketLobby({required this.errorMsg});
}