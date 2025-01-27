import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/domain/use_cases/use_case.dart';
import 'package:aerox_stage_1/features/feature_details/repository/remote/racket_repository.dart';

class GetSelectedRacketUsecase extends AsyncUseCaseWitoutParams<Racket>{

  final RacketRepository racketRepository;
  const GetSelectedRacketUsecase({ required this.racketRepository });
  @override
  Future<EitherErr<Racket>> call() async{
    return racketRepository.getSelectedRacket();
  }
}