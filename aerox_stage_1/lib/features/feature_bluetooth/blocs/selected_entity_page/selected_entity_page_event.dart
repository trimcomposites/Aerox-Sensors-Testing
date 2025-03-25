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