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
  Future<EitherErr<List<Racket>>> getRackets() {

    return datasource.localGetRackets().flatMap((localRackets) {


      if (localRackets.isEmpty) {
        //si no hay rquetas llamamos al remoto para que obtenga raquetas de la api
        return datasource.remotegetRackets().flatMap((remoteRackets) {

          //si es right inserta remoterackets en local
          sqLiteDB.insertRacketList(remoteRackets);

            return datasource.localGetRackets();
          });
        
      } else {

        return Future.value(Right(localRackets));
      }
    });
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