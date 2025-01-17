
import 'package:aerox_stage_1/domain/use_cases/register_user_usecase.dart';
import 'package:aerox_stage_1/domain/user_data.dart';
import 'package:aerox_stage_1/features/feature_login/repository/remote/google_auth_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../ui/login_barrel.dart';
import '../../repository/remote/email_auth_service.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  
  final googleAuthService = GoogleAuthService();
  final registerUserUsecase = RegisterUserUsecase();

  UserBloc( BuildContext context ) : super(UserState()) {
    on<OnGoogleSignInUser>((event, emit) async{
      User? user = await googleAuthService.signInWithGoogle();
      //print( user );
      emit( state.copyWith( user: user, errorMessage: null ) );
    });
    on<OnGoogleSignOutUser>((event, emit) async {
      await googleAuthService.signOut();
      emit( state.copyWith( user: null ) );
    });
    on<OnEmailSignInUser>((event, emit) async {
      var result = await EmailAuthService.signInWithEmail( userData: UserData(name: 'name', email: 'email', password: 'password') );
      if( result is User ){
        emit( state.copyWith( user: result, errorMessage: null ) );
      }else if( result is String ) {
        emit(state.copyWith( errorMessage: result ));
      }
      print( state.errorMessage );

    });
    on<OnEmailSignOutUser>((event, emit) async {
      await EmailAuthService.signOut();
      emit( state.copyWith( user: null ) );

    });

    on<OnEmailRegisterUser>((event, emit) async {
      final userData = UserData(name: 'name', email: event.email, password: event.password );
      var result = await registerUserUsecase.registerUser(userData: userData);
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