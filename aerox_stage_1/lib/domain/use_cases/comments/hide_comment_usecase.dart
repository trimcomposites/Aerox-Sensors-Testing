import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/comment.dart';
import 'package:aerox_stage_1/domain/use_cases/use_case.dart';
import 'package:aerox_stage_1/features/feature_comments/repository/comments_repository.dart';

class HideCommentUsecase extends AsyncUseCaseWithParams<void, Comment>{

  final CommentsRepository commentsRepository;

  HideCommentUsecase({required this.commentsRepository});

  @override
  Future<EitherErr<void>> call(Comment comment) async {
    return await commentsRepository.hideComment(comment);
  }

}