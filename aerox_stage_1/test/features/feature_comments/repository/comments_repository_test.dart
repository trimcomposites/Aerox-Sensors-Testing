import 'package:aerox_stage_1/common/utils/error/err/comment_err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/comment.dart';
import 'package:aerox_stage_1/features/feature_comments/repository/comments_repository.dart';
import 'package:aerox_stage_1/features/feature_comments/repository/local/comment_location_service.dart';
import 'package:aerox_stage_1/features/feature_comments/repository/remote/firestore_comments.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mock_types.dart';


void main() {
  late CommentsRepository commentsRepository;
  late MockFirestoreComments firestoreComments;
  late MockCommentLocationService commentLocationService;

  final comment = Comment(
    id: "123",
    authorId: "userId",
    content: "Nice racket!",
    date: "2024-03-28",
  );

  final commentsList = [comment];

  setUp(() {
    firestoreComments = MockFirestoreComments();
    commentLocationService = MockCommentLocationService();

    commentsRepository = CommentsRepository(
      firestoreComments: firestoreComments,
      commentLocationService: commentLocationService,
    );
  });

  group('getCommentsByRacketId', () {
    test('returns Right with list of comments', () async {
      when(() => firestoreComments.getCommentsByRacketId("1"))
          .thenAnswer((_) async => Right(commentsList));

      final result = await commentsRepository.getCommentsByRacketId("1");

      expect(result, equals(Right(commentsList)));
    });

    test('returns Left when fails', () async {
      when(() => firestoreComments.getCommentsByRacketId("1"))
          .thenAnswer((_) async => Left(CommentErr(errMsg: "Error", statusCode: 1)));

      final result = await commentsRepository.getCommentsByRacketId("1");

      expect(result.isLeft(), true);
    });
  });

  group('saveComment', () {
    test('returns Right when comment saved successfully', () async {
      when(() => firestoreComments.saveComment(comment))
          .thenAnswer((_) async => Right(null));

      final result = await commentsRepository.saveComment(comment);

      expect(result, equals(Right(null)));
    });

    test('returns Left when save fails', () async {
      when(() => firestoreComments.saveComment(comment))
          .thenAnswer((_) async => Left(CommentErr(errMsg: "Save failed", statusCode: 2)));

      final result = await commentsRepository.saveComment(comment);

      expect(result.isLeft(), true);
    });
  });

  group('getCityLocation', () {
    test('returns Right with city name', () async {
      when(() => commentLocationService.getCity())
          .thenAnswer((_) async => Right("Madrid"));

      final result = await commentsRepository.getCityLocation();

      expect(result, equals(Right("Madrid")));
    });

    test('returns Left when fails', () async {
      when(() => commentLocationService.getCity())
          .thenAnswer((_) async => Left(CommentErr(errMsg: "GPS error", statusCode: 3)));

      final result = await commentsRepository.getCityLocation();

      expect(result.isLeft(), true);
    });
  });

  group('hideComment', () {
    test('returns Right when comment hidden successfully', () async {
      when(() => firestoreComments.hideComment(comment.id))
          .thenAnswer((_) async => Right(null));

      final result = await commentsRepository.hideComment(comment);

      expect(result, equals(Right(null)));
    });

    test('returns Left when hiding fails', () async {
      when(() => firestoreComments.hideComment(comment.id))
          .thenAnswer((_) async => Left(CommentErr(errMsg: "Hide failed", statusCode: 4)));

      final result = await commentsRepository.hideComment(comment);

      expect(result.isLeft(), true);
    });
  });
}
