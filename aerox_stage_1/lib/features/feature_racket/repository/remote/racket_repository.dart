import 'package:aerox_stage_1/common/utils/either_catch.dart';
import 'package:aerox_stage_1/common/utils/error/err/racket_err.dart';
import 'package:aerox_stage_1/common/utils/error/err/status_code.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/features/feature_racket/repository/domain/sqlite_db.dart';
import 'package:aerox_stage_1/features/feature_racket/repository/remote/mock_racket_datasource.dart';
import 'package:aerox_stage_1/features/feature_racket/repository/remote/racket_datasource.dart';
import 'package:dartz/dartz.dart';

class RacketRepository {
  final RacketDatasource datasource;
  final SQLiteDB sqLiteDB;

  RacketRepository({required this.datasource, required this.sqLiteDB, });
Future<EitherErr<List<Racket>>> getRackets() async {
  var localRackets = await datasource.localGetRackets();

  return localRackets.fold(
    (l) async {
      var remoteRackets = await datasource.remotegetRackets();

      return remoteRackets.fold(
        (l) {
          print( 'error' );
          return Left( RacketErr( errMsg: '', statusCode: 1 ) );
        },
        (r) async {
          print( 'local save' );
          sqLiteDB.insertRacketList( r );
          return datasource.localGetRackets();  
        },
      );
    },
    (r) {
      return Right(r);
    },
  );
}

  Future<EitherErr<Racket>> getSelectedRacket() async{
    return datasource.getSelectedRacket();
  }
  Future<EitherErr<Racket>> selectRacket( Racket racket ) async{
    return datasource.selectRacket( racket );
  }
  Future<EitherErr<void>> deselectRacket( ) async{
    return datasource.deselectRacket( );
  }
}