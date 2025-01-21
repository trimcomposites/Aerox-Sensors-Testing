
import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/use_cases/email_sign_in_type.dart';
import 'package:aerox_stage_1/domain/use_cases/register_user_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/sign_in_user_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/sign_out_user_usecase.dart';
import 'package:aerox_stage_1/domain/user_data.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/google_auth_service.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/login_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../ui/login_barrel.dart';
import '../../repository/remote/email_auth_service.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {

  final LoginRepository loginRepository;
  
  UserBloc( BuildContext context,  this.loginRepository ) : super(UserState()) {

    final signInUseCase = SignInUserUsecase( loginRepo: loginRepository );
    final signOutUseCase = SignOutUserUsecase( loginRepo: loginRepository );
    final registerUseCase = RegisterUserUsecase( loginRepo: loginRepository );

    on<OnGoogleSignInUser>((event, emit) async{
      // ignore: avoid_single_cascade_in_expression_statements
      await signInUseCase( SignInUserUsecaseParams(signInType: EmailSignInType.google)  )..fold(
      (l) => emit( state.copyWith( errorMessage: l.errMsg ) ),
      (r) => emit( state.copyWith( user: r  ) ));
      print( state.user! );
    });
    on<OnGoogleSignOutUser>((event, emit) async {
      // ignore: avoid_single_cascade_in_expression_statements
      await signOutUseCase(  EmailSignInType.google )..fold(
      (l) => emit( state.copyWith( errorMessage: l.errMsg ) ),
      (r) => emit( state.copyWith( user: null  ) ));
    });
    on<OnEmailSignInUser>((event, emit) async {
      final userData = UserData(name: 'name', email: event.email, password: event.password );
      // ignore: avoid_single_cascade_in_expression_statements
      await signInUseCase( SignInUserUsecaseParams(signInType: EmailSignInType.email, userData: userData) )..fold(
      (l) => emit( state.copyWith( errorMessage: l.errMsg ) ),
      (r) => emit( state.copyWith( user: r, errorMessage: null  ) ));


    });
    on<OnEmailSignOutUser>((event, emit) async {
      // ignore: avoid_single_cascade_in_expression_statements
      await signOutUseCase(  EmailSignInType.email )..fold(
      (l) => emit( state.copyWith( errorMessage: l.errMsg ) ),
      (r) => emit( state.copyWith( user: null  ) ));
      print( state.user );
    });
    on<OnEmailRegisterUser>((event, emit) async {
      final userData = UserData(name: 'name', email: event.email, password: event.password );
      dynamic result = await registerUseCase(userData);
      if( result is User ){
        emit( state.copyWith( user: result, errorMessage: null ) );
      }else if ( result is String ) {
        emit( state.copyWith( errorMessage: result ) );
      }
    });
    on<OnDeleteErrorMsg>((event, emit) {
      emit( state.copyWith( errorMessage: null ) );
          print( state.errorMessage );
    },);
    on<OnCheckUserIsSignedIn>((event, emit) {
      User? user = FirebaseAuth.instance.currentUser;
      emit( state.copyWith( user: user, ) );
      print( user );
    });



  }

}