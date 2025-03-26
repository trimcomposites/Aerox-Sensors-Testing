import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/common/utils/error/err/comment_err.dart';
import 'package:aerox_stage_1/domain/models/aerox_user.dart';
import 'package:aerox_stage_1/domain/models/comment.dart';
import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/domain/use_cases/comments/get_comments_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/comments/get_city_location_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/comments/hide_comment_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/comments/save_comment_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/login/check_user_signed_in_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/get_selected_racket_usecase.dart';
import 'package:aerox_stage_1/features/feature_comments/blocs/bloc/comments_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mock_types.dart';



void main() {
  late CommentsBloc commentsBloc;
  late GetCommentsUsecase getCommentsUsecase;
  late CheckUserSignedInUseCase checkUserSignedInUseCase;
  late GetSelectedRacketUseCase getSelectedRacketUseCase;
  late SaveCommentUsecase saveCommentUsecase;
  late HideCommentUsecase hideCommentUsecase;
  late GetCityLocationUseCase getCityLocationUseCase;

  setUp(() {
    getCommentsUsecase = MockGetCommentsUsecase();
    checkUserSignedInUseCase = MockCheckUserSignedInUseCase();
    getSelectedRacketUseCase = MockGetSelectedRacketUseCase();
    saveCommentUsecase = MockSaveCommentUsecase();
    hideCommentUsecase = MockHideCommentUsecase();
    getCityLocationUseCase = MockGetCityLocationUseCase();

    commentsBloc = CommentsBloc(
      getCommentsUsecase: getCommentsUsecase,
      checkUserSignedInUseCase: checkUserSignedInUseCase,
      getSelectedRacketUseCase: getSelectedRacketUseCase,
      saveCommentUsecase: saveCommentUsecase,
      hideCommentUsecase: hideCommentUsecase,
      getCityLocationUseCase: getCityLocationUseCase,
    );
  });
  setUpAll(() {
    registerFallbackValue(Comment(id: "1", authorId: "123", content: "Test comment", date: ""));
  });

  tearDown(() {
    commentsBloc.close();
  });
  final Comment comment = Comment(id: "2", authorId: "456", content: "Not bad!", date: '');
  final List<Comment> commentsList = [
    Comment(id: "1", authorId: "123", content: "Great racket!", date: ''),
    Comment(id: "2", authorId: "456", content: "Not bad!", date: ''),
  ];

  final AeroxUser user = AeroxUser(id: "123", name: "John Doe", email: "john@example.com");
  final Racket racket = Racket( acorMax: 1, acorMin: 1, balanceMax: 1, balanceMin: 1, maneuverabilityMax: 1, maneuverabilityMin: 1,
   swingWeightMax: 1, swingWeightMin: 1, weightMax: 1, weightMin: 1, isSelected: true, id: 1, hit: '', 
   frame: '', racketName: '', color: '', weightNumber: 1, weightName: '', weightType: '', balance: 1, headType: '', swingWeight: 1,
   powerType: '', acor: 1, acorType: '', maneuverability: 1, maneuverabilityType: '', image: '', model: ''  );
  group('OnGetRacketComments', () {
    blocTest<CommentsBloc, CommentsState>(
      'emits [loading, idle] when getting comments is successful',
      build: () {
        when(() => getCommentsUsecase.call(any())).thenAnswer((_) async => Right(commentsList));
        return commentsBloc;
      },
      act: (bloc) => bloc.add(OnGetRacketComments(racketId: '1')),
      expect: () => [
        CommentsState(uistate: UIState.loading()),
        CommentsState(uistate: UIState.idle(), comments: commentsList),
      ],
    );

    blocTest<CommentsBloc, CommentsState>(
      'emits [loading, error] when getting comments fails',
      build: () {
        when(() => getCommentsUsecase.call(any())).thenAnswer((_) async => Left(CommentErr(errMsg: "Failed to fetch comments", statusCode: 1)));
        return commentsBloc;
      },
      act: (bloc) => bloc.add(OnGetRacketComments(racketId: '1')),
      expect: () => [
        CommentsState(uistate: UIState.loading()),
        CommentsState(uistate: UIState.error("Failed to fetch comments")),
      ],
    );
  });

  group('OnGetCurrentUser', () {
    blocTest<CommentsBloc, CommentsState>(
      'emits [loading, idle] when fetching user is successful',
      build: () {
        when(() => checkUserSignedInUseCase.call()).thenAnswer((_) async => Right(user));
        return commentsBloc;
      },
      act: (bloc) => bloc.add(OnGetCurrentUser()),
      expect: () => [
        CommentsState(uistate: UIState.loading()),
        CommentsState(uistate: UIState.idle(), user: user),
      ],
    );
  });

  group('OnGetSelectedRacketComments', () {
    blocTest<CommentsBloc, CommentsState>(
      'emits [loading, idle] when fetching selected racket is successful',
      build: () {
        when(() => getSelectedRacketUseCase.call()).thenAnswer((_) async => Right(racket));
        return commentsBloc;
      },
      act: (bloc) => bloc.add(OnGetSelectedRacketComments()),
      expect: () => [
        CommentsState(uistate: UIState.loading()),
        CommentsState(uistate: UIState.idle(), racket: racket),
      ],
    );
  });

  group('OnSaveComment', () {
blocTest<CommentsBloc, CommentsState>(
  'emits [loading, success] when saving comment is successful',
  build: () {
    when(() => saveCommentUsecase.call(any())).thenAnswer((_) async => Right(unit)); // ✅ CORREGIDO
    return commentsBloc;
  },
  act: (bloc) => bloc.add(OnSaveComment(comment: commentsList.first)),
  expect: () => [
    CommentsState(uistate: UIState.loading()),
    CommentsState(uistate: UIState.success()),
  ],
);
  });

  group('OnHideComment', () {
    blocTest<CommentsBloc, CommentsState>(
      'emits [loading, success] when hiding comment is successful',
      build: () {
        when(() => hideCommentUsecase.call(any())).thenAnswer((_) async => Right(unit));
        return commentsBloc;
      },
      act: (bloc) => bloc.add(OnHideComment(comment: commentsList.first)),
      expect: () => [
        CommentsState(uistate: UIState.loading()),
        CommentsState(uistate: UIState.success()),
      ],
    );
  });

  group('OnGetCityLocation', () {
    blocTest<CommentsBloc, CommentsState>(
      'emits [loading, idle] when fetching city location is successful',
      build: () {
        when(() => getCityLocationUseCase.call()).thenAnswer((_) async => Right("New York"));
        return commentsBloc;
      },
      act: (bloc) => bloc.add(OnGetCityLocation()),
      expect: () => [
        CommentsState(uistate: UIState.loading()),
        CommentsState(uistate: UIState.idle(), city: "New York"),
      ],
    );
  });
}
