import 'package:aerox_stage_1/common/utils/error/err/comment_err.dart';
import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/comment.dart';
import 'package:aerox_stage_1/domain/use_cases/comments/get_comments_usecase.dart';
import 'package:aerox_stage_1/features/feature_comments/repository/comments_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import '../../../mock_types.dart';

void main() {
  late GetCommentsUsecase getCommentsUsecase;
  late CommentsRepository commentsRepository;

  setUp(() {
    commentsRepository = MockCommentsRepository();
    getCommentsUsecase = GetCommentsUsecase(commentsRepository: commentsRepository);
  });

  const String racketId = "123";

  final List<Comment> commentsList = [
    Comment(id: "1", authorId: "123", content: "Great racket!", date: "2024-03-26"),
    Comment(id: "2", authorId: "456", content: "Not bad!", date: "2024-03-26"),
  ];

  group('GetCommentsUsecase', () {
    test('should return Right(List<Comment>) when getting comments is successful', () async {
      when(() => commentsRepository.getCommentsByRacketId(racketId))
          .thenAnswer((_) async => Right(commentsList));

      final result = await getCommentsUsecase(racketId);

      expect(result, equals(Right<Err, List<Comment>>(commentsList)));
      verify(() => commentsRepository.getCommentsByRacketId(racketId)).called(1);
    });

    test('should return Left(Err) when getting comments fails', () async {
      final error = CommentErr(errMsg: "Failed to fetch comments", statusCode: 500);
      when(() => commentsRepository.getCommentsByRacketId(racketId))
          .thenAnswer((_) async => Left(error));

      final result = await getCommentsUsecase(racketId);

      expect(result, isA<Left<Err, List<Comment>>>());
      verify(() => commentsRepository.getCommentsByRacketId(racketId)).called(1);
    });
  });
}
