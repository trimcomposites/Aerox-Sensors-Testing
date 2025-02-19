import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/domain/models/aerox_user.dart';
import 'package:aerox_stage_1/domain/use_cases/login/check_user_signed_in_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/email_sign_in_type.dart';
import 'package:aerox_stage_1/domain/use_cases/login/register_user_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/reset_password_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/sign_in_user_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/sign_out_user_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final SignOutUserUseCase signOutUseCase; 
  final RegisterUserUseCase registerUseCase;
  final SignInUserUseCase signInUsecase;
  final CheckUserSignedInUseCase checkUserSignedInUsecase;
  final ResetPasswordUseCase resetPasswordUsecase;

  UserBloc({ 
    required this.signInUsecase, 
    required this.signOutUseCase, 
    required this.registerUseCase, 
    required this.checkUserSignedInUsecase, 
    required this.resetPasswordUsecase,
  }) : super(UserState(uiState: UIState.loading())) {
       on<OnGoogleSignInUser>((event, emit) async {
      add(OnStartLoadingUser());
      final result = await signInUsecase(SignInUserUsecaseParams(signInType: EmailSignInType.google));
      result.fold(
        (l) {
          add(OnStartErrorUser(errorMessage: l.errMsg));
        },
        (r) {
          emit(state.copyWith(user: r, uiState: UIState.success()));
          add(OnStopLoadingUser());
        },
      );
    });

    on<OnGoogleSignOutUser>((event, emit) async {
      add(OnStartLoadingUser());
      await signOutUseCase(EmailSignInType.google);
      emit(state.copyWith(user: null, uiState: UIState.success()));
      add(OnStopLoadingUser());
    });

    on<OnEmailSignInUser>((event, emit) async {
      add(OnStartLoadingUser());
      final user = AeroxUser(name: 'name', email: event.email, password: event.password);
      final result = await signInUsecase(SignInUserUsecaseParams(signInType: EmailSignInType.email, user: user));
      result.fold(
        (l) {
          add(OnStartErrorUser(errorMessage: l.errMsg));
        },
        (r) {
          emit(state.copyWith(user: r, uiState: UIState.success()));
          add(OnStopLoadingUser());
        },
      );
    });

    on<OnEmailSignOutUser>((event, emit) async {
      add(OnStartLoadingUser());
      await signOutUseCase(EmailSignInType.email);
      emit(state.copyWith(user: null, uiState: UIState.success()));
      add(OnStopLoadingUser());
    });

    on<OnEmailRegisterUser>((event, emit) async {
      add(OnStartLoadingUser());
      final user = AeroxUser(name: 'name', email: event.email, password: event.password);
      final result = await registerUseCase(user);
      result.fold(
        (l) {
          add(OnStartErrorUser(errorMessage: l.errMsg));
        },
        (r) {
          emit(state.copyWith(user: r, uiState: UIState.success()));
          add(OnStopLoadingUser());
        },
      );
    });

    on<OnCheckUserIsSignedIn>((event, emit) async {
      add(OnStartLoadingUser());
      final result = await checkUserSignedInUsecase();
      result.fold(
        (l) {
          emit(state.copyWith(user: null, uiState: UIState.success()));
          add(OnStopLoadingUser());
        },
        (r) {
          emit(state.copyWith(user: r, uiState: UIState.success()));
          add(OnStopLoadingUser());
        },
      );
    });

    on<OnPasswordReset>((event, emit) async {
      add(OnStartLoadingUser());
      final result = await resetPasswordUsecase(event.email);
      result.fold(
        (l) {
          add(OnStartErrorUser(errorMessage: l.errMsg));
        },
        (r) {
          emit(state.copyWith(uiState: UIState.success()));
          add(OnStopLoadingUser());
        },
      );
    });
    
    on<OnStartLoadingUser>((event, emit) async {
      emit(state.copyWith(uiState: UIState.loading()));
    });

    on<OnStopLoadingUser>((event, emit) async {
      emit(state.copyWith(uiState: UIState.success()));
    });

    on<OnOperationSuccessUser>((event, emit) async {
      emit(state.copyWith(uiState: UIState.success()));
    });

    on<OnStartErrorUser>((event, emit) async {
      emit(state.copyWith(uiState: UIState.error(event.errorMessage)));
    });

    on<OnStopErrorUser>((event, emit) async {
      emit(state.copyWith(uiState: UIState.success()));
    });
    on<OnDeleteErrorMsg>((event, emit) async {
      emit(state.copyWith(uiState: UIState.success()));
    });

  }
  
}
