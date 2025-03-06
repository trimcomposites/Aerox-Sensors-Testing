import 'package:aerox_stage_1/common/services/download_file.dart';
import 'package:aerox_stage_1/common/utils/either_catch.dart';
import 'package:aerox_stage_1/common/utils/error/err/racket_err.dart';
import 'package:aerox_stage_1/common/utils/error/err/sign_in_err.dart';
import 'package:aerox_stage_1/common/utils/error/err/status_code.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/features/feature_racket/repository/local/rackets_sqlite_db.dart';
import 'package:aerox_stage_1/features/feature_racket/repository/remote/remote_get_rackets.dart';
import 'package:dartz/dartz.dart';
import 'package:dartz/dartz_unsafe.dart';

class RacketRepository {

  //futuras dependencias
  RacketRepository( { 
    required this.sqLiteDB, required this.remoteGetRackets, required this.downloadFile
  });
  final RacketsSQLiteDB sqLiteDB;
  final RemoteGetRackets remoteGetRackets;
  final DownloadFile downloadFile;


  Future<EitherErr<List<Racket>>>remotegetRackets() async {
    return EitherCatch.catchAsync<List<Racket>, RacketErr>(() async {
      final racketList = await remoteGetRackets.fetchData();
      return racketList;


    }, (exception) => RacketErr(errMsg: exception.toString(), statusCode: StatusCode.authenticationFailed));
  } 
  
  Future<EitherErr<List<Racket>>>localGetRackets() {
    return EitherCatch.catchAsync<List<Racket>, RacketErr>(() async {
      final localRackets =  await sqLiteDB.getAllRackets();
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
Future<EitherErr<List<Racket>>> downloadRacketModels() async {
  return EitherCatch.catchAsync<List<Racket>, RacketErr>(() async {
    final eitherLocalRackets = await localGetRackets();

    return eitherLocalRackets.fold(
      (failure) => throw Exception(), // Si hay un error, lo retornamos inmediatamente
      (localRackets) async {
        for (var racket in localRackets) {
          if (racket.model.startsWith("http://") || racket.model.startsWith("https://")) {
            final modelPath = await downloadFile.downloadFile(racket.model, racket.docId);
            await sqLiteDB.updateRacketModel(racket.docId, modelPath);
          }
        }
        return Future.value(localRackets); // Devolvemos la lista actualizada dentro de un Either
      },
    );
  }, (exception) => RacketErr(errMsg: exception.toString(), statusCode: StatusCode.authenticationFailed));
}
Future<EitherErr<List<Racket>>> downloadRacketImages() async {
  return EitherCatch.catchAsync<List<Racket>, RacketErr>(() async {
    final eitherLocalRackets = await localGetRackets();

    return eitherLocalRackets.fold(
      (failure) => throw Exception(), // Si hay un error, lo retornamos inmediatamente
      (localRackets) async {
        for (var racket in localRackets) {
          if (racket.image.startsWith("http://") || racket.image.startsWith("https://")) {
            final imagePath = await downloadFile.downloadFile(racket.image, racket.docId+'image');
            await sqLiteDB.updateRacketImage(racket.docId, imagePath);
          }
        }
        return Future.value(localRackets); // Devolvemos la lista actualizada dentro de un Either
      },
    );
  }, (exception) => RacketErr(errMsg: exception.toString(), statusCode: StatusCode.authenticationFailed));
}

  //TOD: Este metodo es sustituido en debug
 Future<EitherErr<List<Racket>>> getRackets() {

     return localGetRackets().flatMap((localRackets) {


       if (localRackets.isEmpty) {
         //si no hay rquetas llamamos al remoto para que obtenga raquetas de la api
         return remotegetRackets().flatMap((remoteRackets) async {

           //si es right inserta remoterackets en local
           await sqLiteDB.insertRacketList(remoteRackets);

             return localGetRackets();
           });
      
       } else {

         return Future.value(Right(localRackets));
       }
     });
   }
  // Future<EitherErr<List<Racket>>> getRackets() {

      
  //     return remotegetRackets();


  //   }


}

