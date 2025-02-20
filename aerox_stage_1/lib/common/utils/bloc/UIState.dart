import 'package:equatable/equatable.dart';

enum UIStatus { loading, success, error, idle }

class UIState extends Equatable {
  final UIStatus status;
  final String errorMessage;
  final String? next;

  const UIState({
    required this.status,
    this.errorMessage ='',
    this.next
  });

  factory UIState.loading() => const UIState(
    status: UIStatus.loading,
    next: null
  );
  factory UIState.success( {String? next} ) => UIState(
    status: UIStatus.success,
    next: next
  );
  factory UIState.error(String errorMessage) => UIState(
    status: UIStatus.error,
    errorMessage: errorMessage,
    next: null
  );

  @override
  List<Object?> get props => [status, errorMessage, next];
}