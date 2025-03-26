import 'package:aerox_stage_1/common/utils/error/err/comment_err.dart';
import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/comment.dart';
import 'package:aerox_stage_1/domain/use_cases/comments/save_comment_usecase.dart';
import 'package:aerox_stage_1/features/feature_comments/repository/comments_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import '../../../mock_types.dart';

void main() {
  late SaveCommentUsecase saveCommentUsecase;
  late CommentsRepository commentsRepository;

  setUp(() {
    commentsRepository = MockCommentsRepository();
    saveCommentUsecase = SaveCommentUsecase(commentsRepository: commentsRepository);
  });

  final Comment comment = Comment(id: "1", authorId: "123", content: "This is a comment", date: "2024-03-26");

  group('SaveCommentUsecase', () {
    test('should return Right(void) when saving a comment is successful', () async {
      when(() => commentsRepository.saveComment(comment))
          .thenAnswer((_) async => Right(unit));

      final result = await saveCommentUsecase(comment);

      expect(result, equals(Right<Err, void>(unit)));
      verify(() => commentsRepository.saveComment(comment)).called(1);
    });

    test('should return Left(Err) when saving a comment fails', () async {
      final error = CommentErr(errMsg: "Failed to save comment", statusCode: 500);
      when(() => commentsRepository.saveComment(comment))
          .thenAnswer((_) async => Left(error));

      final result = await saveCommentUsecase(comment);

      expect(result, isA<Left<Err, void>>());
      verify(() => commentsRepository.saveComment(comment)).called(1);
    });
  });
}
