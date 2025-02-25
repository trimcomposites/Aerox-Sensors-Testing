import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/use_cases/use_case.dart';
import 'package:aerox_stage_1/features/feature_comments/repository/comments_repository.dart';

class GetCityLocationUseCase extends AsyncUseCaseWithoutParams<String>{

  final CommentsRepository commentsRepository;

  GetCityLocationUseCase({required this.commentsRepository});

  @override
  Future<EitherErr<String>> call() {
    return commentsRepository.getCityLocation();
  }

}
