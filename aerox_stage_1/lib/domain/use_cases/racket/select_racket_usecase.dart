import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/domain/use_cases/use_case.dart';
import 'package:aerox_stage_1/features/feature_details/repository/remote/racket_repository.dart';

class SelectRacketUsecase extends AsyncUseCaseWithParams<void, Racket>{

  final RacketRepository racketRepository;
  const SelectRacketUsecase({ required this.racketRepository });
  @override
  Future<EitherErr<Racket>> call( params ) async{
    return await racketRepository.selectRacket( params );
  }
}