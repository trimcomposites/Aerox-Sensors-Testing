import 'package:aerox_stage_1/common/utils/either_catch.dart';
import 'package:aerox_stage_1/common/utils/error/err/racket_err.dart';
import 'package:aerox_stage_1/common/utils/error/err/sign_in_err.dart';
import 'package:aerox_stage_1/common/utils/error/err/status_code.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/features/feature_racket/repository/domain/sqlite_db.dart';
import 'package:aerox_stage_1/features/feature_racket/repository/remote/remote_get_rackets.dart';

class RacketDatasource {

  //futuras dependencias
  RacketDatasource({ 
    required this.sqLiteDB
  });
  final SQLiteDB sqLiteDB;
  final RemoteGetRackets remoteGetRackets = RemoteGetRackets();


  Future<EitherErr<List<Racket>>>remotegetRackets() async {
    return EitherCatch.catchAsync<List<Racket>, RacketErr>(() async {
      final racketList = await remoteGetRackets.fetchData();
      return racketList;


    }, (exception) => RacketErr(errMsg: exception.toString(), statusCode: StatusCode.authenticationFailed));
  } 
  
  Future<EitherErr<List<Racket>>>localGetRackets() {
    return EitherCatch.catchAsync<List<Racket>, RacketErr>(() async {
      final localRackets =  await sqLiteDB.getAllRackets();
      if( localRackets.isEmpty ) throw Exception();
      return localRackets;
    }, (exception) => RacketErr(errMsg: exception.toString(), statusCode: StatusCode.authenticationFailed));
  } 
  
  Future<EitherErr<Racket>> getSelectedRacket() async{
    return EitherCatch.catchAsync<Racket, RacketErr>(() async{
      final result= await sqLiteDB.getSelectedRacket();
      if(result== null){
        throw Exception(); 
      }
      return result;
    }, (exception) => RacketErr(errMsg: exception.toString(), statusCode: StatusCode.authenticationFailed));
  }
  Future<EitherErr<Racket>> selectRacket( Racket racket ) async{
    return EitherCatch.catchAsync<Racket, RacketErr>(() async{     
      await sqLiteDB.selectRacket( racket.id );
  
      return racket;
    }, (exception) => RacketErr(errMsg: exception.toString(), statusCode: StatusCode.authenticationFailed));
  }
  Future<EitherErr<void>> deselectRacket() async{
    return EitherCatch.catchAsync<void, RacketErr>(() async {
      await sqLiteDB.deselectAllRackets();
    
    }, (exception) => RacketErr(errMsg: exception.toString(), statusCode: StatusCode.authenticationFailed));
  }



}
