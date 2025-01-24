import 'package:aerox_stage_1/common/utils/either_catch.dart';
import 'package:aerox_stage_1/common/utils/error/err/racket_err.dart';
import 'package:aerox_stage_1/common/utils/error/err/sign_in_err.dart';
import 'package:aerox_stage_1/common/utils/error/err/status_code.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/racket.dart';

class MockRacketDatasource {

  //futuras dependencias
  const MockRacketDatasource();


  Future<EitherErr<List<Racket>>>remotegetRackets() async {
    return EitherCatch.catchAsync<List<Racket>, RacketErr>(() async {
      return mockRackets;

    }, (exception) => RacketErr(errMsg: exception.toString(), statusCode: StatusCode.authenticationFailed));
  } 
  
  EitherErr<List<Racket>>localGetRackets() {
    return EitherCatch.catchE<List<Racket>, RacketErr>(() {
      return  mockRackets;
    }, (exception) => RacketErr(errMsg: exception.toString(), statusCode: StatusCode.authenticationFailed));
  } 
  



}
List<Racket> mockRackets = [
  Racket(
    name: 'PowerDrive 300',
    length: 68.0,
    weight: 320.0,
    img: 'https://example.com/powerdrive300.png',
    pattern: '16x19',
    balance: 305.0,
  ),
  Racket(
    name: 'SpeedMaster 270',
    length: 67.5,
    weight: 280.0,
    img: 'https://example.com/speedmaster270.png',
    pattern: '18x20',
    balance: 295.0,
  ),
  Racket(
    name: 'ControlPro 295',
    length: 69.0,
    weight: 295.0,
    img: 'https://example.com/controlpro295.png',
    pattern: '16x18',
    balance: 300.0,
  ),
  Racket(
    name: 'SpinX 310',
    length: 68.5,
    weight: 310.0,
    img: 'https://example.com/spinx310.png',
    pattern: '14x16',
    balance: 310.0,
  ),
  Racket(
    name: 'PowerFusion 325',
    length: 70.0,
    weight: 325.0,
    img: 'https://example.com/powerfusion325.png',
    pattern: '16x19',
    balance: 315.0,
  ),
  Racket(
    name: 'AceStrike 280',
    length: 67.0,
    weight: 280.0,
    img: 'https://example.com/acestrike280.png',
    pattern: '18x20',
    balance: 290.0,
  ),
];