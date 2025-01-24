import 'package:aerox_stage_1/common/utils/either_catch.dart';
import 'package:aerox_stage_1/common/utils/error/err/racket_err.dart';
import 'package:aerox_stage_1/common/utils/error/err/status_code.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/features/feature_details/repository/remote/mock_racket_datasource.dart';
import 'package:dartz/dartz.dart';

class RacketRepository {
  final MockRacketDatasource datasource;

  RacketRepository({required this.datasource});

  Future<EitherErr<List<Racket>>> getRackets( {required bool remote} ) async {
    datasource.remotegetRackets();
    if ( remote) {
      return datasource.remotegetRackets();
    }else{
      return right([]);
    }
  } 
}