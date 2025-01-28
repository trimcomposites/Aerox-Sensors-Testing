import 'package:aerox_stage_1/common/utils/either_catch.dart';
import 'package:aerox_stage_1/common/utils/error/err/racket_err.dart';
import 'package:aerox_stage_1/common/utils/error/err/sign_in_err.dart';
import 'package:aerox_stage_1/common/utils/error/err/status_code.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/features/feature_racket/repository/domain/sqlite_db.dart';

class MockRacketDatasource {

  //futuras dependencias
  MockRacketDatasource({ 
    required this.sqLiteDB
  });
  final SQLiteDB sqLiteDB;



  Future<EitherErr<List<Racket>>>remotegetRackets() async {
    return EitherCatch.catchAsync<List<Racket>, RacketErr>(() async {
      return mockRackets;

    }, (exception) => RacketErr(errMsg: exception.toString(), statusCode: StatusCode.authenticationFailed));
  } 
  
  Future<EitherErr<List<Racket>>>localGetRackets() {
    return EitherCatch.catchAsync<List<Racket>, RacketErr>(() async {
      return await sqLiteDB.getAllRackets();
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
List<Racket> mockRackets = [
  Racket(
    id: 1,
    name: 'PowerDrive 300',
    length: 68.0,
    weight: 320.0,
    img: 'https://www.paddlecoach.com/wp-content/uploads/2023/07/foto__0015.png',
    pattern: '16x19',
    balance: 305.0,
  ),
  Racket(
    id: 2,
    name: 'SpeedMaster 270',
    length: 67.5,
    weight: 280.0,
    img: 'https://royalpadel.com/wp-content/uploads/2023/11/PALA_PADEL_19-3_PNG-54.png',
    pattern: '18x20',
    balance: 295.0,
  ),
  Racket(
    id: 3,
    name: 'ControlPro 295',
    length: 69.0,
    weight: 295.0,
    img: 'https://royalpadel.com/wp-content/uploads/2023/11/PALA_PADEL_19-3_PNG-20.png',
    pattern: '16x18',
    balance: 300.0,
  ),
  Racket(
    id: 4,
    name: 'SpinX 310',
    length: 68.5,
    weight: 310.0,
    img: 'https://padelusa.com/cdn/shop/files/Head-Zephyr_UL_Padel_Racket_PadelUSA_store_1.webp?v=1711729439',
    pattern: '14x16',
    balance: 310.0,
  ),
  Racket(
    id: 5,
    name: 'PowerFusion 325',
    length: 70.0,
    weight: 325.0,
    img: 'https://padelusa.com/cdn/shop/files/Head-Speed_Motion_Padel_Racket_PadelUSA_store_1.webp?v=1711746212',
    pattern: '16x19',
    balance: 315.0,
  ),

];