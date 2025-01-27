import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/domain/use_cases/use_case.dart';
import 'package:aerox_stage_1/features/feature_details/repository/remote/racket_repository.dart';

class DeselectRacketUsecase extends AsyncUseCaseWitoutParams<void>{

  final RacketRepository racketRepository;
  const DeselectRacketUsecase({ required this.racketRepository });
  @override
  Future<EitherErr<void>> call() async{
    return await racketRepository.deselectRacket();
  }
}