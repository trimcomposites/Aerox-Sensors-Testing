import 'package:aerox_stage_1/common/utils/error/err/comment_err.dart';
import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/comment.dart';
import 'package:aerox_stage_1/domain/use_cases/comments/hide_comment_usecase.dart';
import 'package:aerox_stage_1/features/feature_comments/repository/comments_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import '../../../mock_types.dart';

void main() {
  late HideCommentUsecase hideCommentUsecase;
  late CommentsRepository commentsRepository;

  setUp(() {
    commentsRepository = MockCommentsRepository();
    hideCommentUsecase = HideCommentUsecase(commentsRepository: commentsRepository);
  });

  final Comment comment = Comment(id: "1", authorId: "123", content: "Hidden comment", date: "2024-03-26");

  group('HideCommentUsecase', () {
    test('should return Right(void) when hiding a comment is successful', () async {
      when(() => commentsRepository.hideComment(comment))
          .thenAnswer((_) async => Right(unit));

      final result = await hideCommentUsecase(comment);

      expect(result, equals(Right<Err, void>(unit)));
      verify(() => commentsRepository.hideComment(comment)).called(1);
    });

    test('should return Left(Err) when hiding a comment fails', () async {
      final error = CommentErr(errMsg: "Failed to hide comment", statusCode: 500);
      when(() => commentsRepository.hideComment(comment))
          .thenAnswer((_) async => Left(error));

      final result = await hideCommentUsecase(comment);

      expect(result, isA<Left<Err, void>>());
      verify(() => commentsRepository.hideComment(comment)).called(1);
    });
  });
}
