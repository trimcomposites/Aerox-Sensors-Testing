import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/domain/models/aerox_user.dart';
import 'package:aerox_stage_1/domain/models/comment.dart';
import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/domain/use_cases/comments/get_comments_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/comments/get_city_location_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/comments/save_comment_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/check_user_signed_in_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/get_selected_racket_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'comments_event.dart';
part 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final GetCommentsUsecase getCommentsUsecase;
  final CheckUserSignedInUseCase checkUserSignedInUseCase;
  final GetSelectedRacketUseCase getSelectedRacketUseCase;
  final SaveCommentUsecase saveCommentUsecase;
  final GetCityLocationUseCase getCityLocationUseCase;
  CommentsBloc({
    required this.getCommentsUsecase,
    required this.checkUserSignedInUseCase,
    required this.getSelectedRacketUseCase,
    required this.saveCommentUsecase,
    required this.getCityLocationUseCase
  }) : super(CommentsState( uistate: UIState.idle() )) {
    on<OnGetRacketComments>((event, emit) async {
      emit( state.copyWith( uistate: UIState.loading() ) );
      //await Future.delayed(Duration(seconds: 5));
     final result = await getCommentsUsecase.call(event.racketId.toString());

      result.fold(
        (l) { emit(state.copyWith( uistate: UIState.error( l.errMsg)));},
        (r) {  emit( state.copyWith( comments: r, uistate: UIState.idle() )); },
      );

    });
    on<OnGetCurrentUser>((event, emit) async {

      emit( state.copyWith( uistate: UIState.loading() ) );
     final result = await checkUserSignedInUseCase.call();
      result.fold(
        (l) { emit(state.copyWith( uistate: UIState.error( l.errMsg)));},
        (r) {  emit( state.copyWith( user: r, uistate: UIState.idle() )); },
      );

    });
    on<OnGetSelectedRacketComments>((event, emit) async {

      emit( state.copyWith( uistate: UIState.loading() ) );
      await Future.delayed( Duration( seconds: 6 ) );
     final result = await getSelectedRacketUseCase.call();
      result.fold(
        (l) { emit(state.copyWith( uistate: UIState.error( l.errMsg)));},
        (r) {  emit( state.copyWith( racket: r, uistate: UIState.idle() )); },
      );

    });

    on<OnSaveComment>((event, emit) async {

      emit( state.copyWith( uistate: UIState.loading() ) );
     final result = await saveCommentUsecase.call( event.comment );
      result.fold(
        (l) { emit(state.copyWith( uistate: UIState.error( l.errMsg)));},
        (r) {  emit( state.copyWith( uistate: UIState.success( ) )); },
      );

    });
    on<OnGetCityLocation>((event, emit) async {

      emit( state.copyWith( uistate: UIState.loading() ) );
     final result = await getCityLocationUseCase.call();
      result.fold(
        (l) { emit(state.copyWith( uistate: UIState.error( l.errMsg)));},
        (r) {  emit( state.copyWith(  city: r, uistate: UIState.success( ) )); },
      );

    });
  }
}
