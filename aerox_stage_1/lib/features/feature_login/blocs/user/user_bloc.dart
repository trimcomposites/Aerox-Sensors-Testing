import 'package:aerox_stage_1/domain/use_cases/login/email_sign_in_type.dart';
import 'package:aerox_stage_1/domain/use_cases/login/register_user_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/sign_in_user_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/sign_out_user_usecase.dart';
import 'package:aerox_stage_1/domain/user_data.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {



  final SignOutUserUsecase signOutUseCase; 
  final RegisterUserUsecase registerUseCase;
    final SignInUserUsecase signInUsecase;
  final FirebaseAuth firebaseAuth;

  UserBloc({ required this.signInUsecase, required this.signOutUseCase, required this.registerUseCase , required this.firebaseAuth }) : super(UserState()) {

    on<OnGoogleSignInUser>((event, emit) async{
      // ignore: avoid_single_cascade_in_expression_statements
      await signInUsecase( SignInUserUsecaseParams(signInType: EmailSignInType.google)  )..fold(
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
      await signInUsecase( SignInUserUsecaseParams(signInType: EmailSignInType.email, userData: userData) )..fold(
      (l) => emit( state.copyWith( errorMessage: l.errMsg ) ),
      (r) => emit( state.copyWith( user: r, errorMessage: null  ) ));


    });
    on<OnEmailSignOutUser>((event, emit) async {
      // ignore: avoid_single_cascade_in_expression_statements
      await signOutUseCase(  EmailSignInType.email )..fold(
      (l) => emit( state.copyWith( errorMessage: l.errMsg ) ),
      (r) => emit( state.copyWith( user: null, errorMessage: null ) ));
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
      User? user = firebaseAuth.currentUser;
      emit( state.copyWith( user: user, ) );
      print( user );
    });



  }

}