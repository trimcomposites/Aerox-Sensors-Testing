part of 'rtsos_lobby_bloc.dart';

@immutable
sealed class RtsosLobbyEvent {}

class OnHitTypeValueChanged extends RtsosLobbyEvent {
  final String newValue;
  OnHitTypeValueChanged(this.newValue);
}