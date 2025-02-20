part of 'user_bloc.dart';

class UserState extends Equatable {
  final AeroxUser? user;
  final UIState uiState;

  const UserState({
    this.user,
    required this.uiState,
  });

  UserState copyWith({
    AeroxUser? user,
    UIState? uiState,
  }) {
    return UserState(
      user: user,
      uiState: uiState ?? this.uiState,
    );
  }

  @override
  List<Object?> get props => [user, uiState];
}