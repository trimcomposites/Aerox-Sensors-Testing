
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/aerox_user.dart';
import 'package:aerox_stage_1/domain/models/comment.dart';
import 'package:aerox_stage_1/domain/use_cases/use_case.dart';
import 'package:aerox_stage_1/features/feature_comments/repository/comments_repository.dart';

class GetCommentsUsecase extends AsyncUseCaseWithParams<List<Comment>, String>{

  const GetCommentsUsecase({ required this.commentsRepository  });

  final CommentsRepository commentsRepository;

  @override
  Future<EitherErr<List<Comment>>> call( String racketId  ) {
    
    final comments = commentsRepository.getCommentsByRacketId(  racketId );
    return comments;

  } 


}