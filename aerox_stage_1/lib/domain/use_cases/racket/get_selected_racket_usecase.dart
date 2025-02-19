import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/domain/use_cases/use_case.dart';
import 'package:aerox_stage_1/features/feature_racket/repository/racket_repository.dart';

class GetSelectedRacketUseCase extends AsyncUseCaseWithoutParams<Racket>{

  final RacketRepository racketRepository;
  const GetSelectedRacketUseCase({ required this.racketRepository });
  @override
  Future<EitherErr<Racket>> call() async{
    return racketRepository.getSelectedRacket();
  }
}