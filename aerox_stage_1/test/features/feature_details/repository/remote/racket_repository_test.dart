import 'package:aerox_stage_1/common/services/download_file.dart';
import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/common/utils/error/err/racket_err.dart';
import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/features/feature_racket/repository/local/rackets_sqlite_db.dart';
import 'package:aerox_stage_1/features/feature_racket/repository/racket_repository.dart';
import 'package:aerox_stage_1/features/feature_racket/repository/remote/remote_get_rackets.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mock_types.dart';


void main() {
  late RacketRepository repository;
  late DownloadFile downloadFile;
  late RemoteGetRackets remoteGetRackets;
  late RacketsSQLiteDB sqLiteDB;
  setUp((){
    downloadFile = MockDownloadFile();
    repository = MockRacketRepository();
    remoteGetRackets = MockRemoteGetRackets();
    sqLiteDB = MockSQLiteDB();
    repository = RacketRepository( sqLiteDB: sqLiteDB, remoteGetRackets: remoteGetRackets, downloadFile: downloadFile);
  });

  const List<Racket> mockRackets = [];
    final Racket racket = Racket( acorMax: 1, acorMin: 1, balanceMax: 1, balanceMin: 1, maneuverabilityMax: 1, maneuverabilityMin: 1,
   swingWeightMax: 1, swingWeightMin: 1, weightMax: 1, weightMin: 1, isSelected: true, id: 1, hit: '', 
   frame: '', racketName: '', color: '', weightNumber: 1, weightName: '', weightType: '', balance: 1, headType: '', swingWeight: 1,
   powerType: '', acor: 1, acorType: '', maneuverability: 1, maneuverabilityType: '', image: '', model: ''  );
  final RacketErr racketErr = RacketErr(errMsg: 'errMsg', statusCode: 1);

    group('remote get rackets', (){
      test('success get rackets, must return [ List<Racket> ]', ()async{
        
        //arrange
        when(() => remoteGetRackets.fetchData()
        ).thenAnswer( ( _ ) async =>   mockRackets );
        //act
        final rackets = await repository.getRackets();
        //assert
        expect(rackets, isA< Right<Err, List<Racket>>>());

      });
      test('failure get rackets, must return [ RAcketErr]', ()async{
        //arrange
        when(() => repository.remotegetRackets()
        ).thenAnswer( ( _ ) async => Left( racketErr )  );
        //act
        final rackets = await repository.getRackets();
        //assert
        expect(rackets, isA< Left<Err, List<Racket>>>());


      });
    });
    group('remote get selected racket', (){
      test('success get selected racket, must return [ Racket ]', ()async{
        
        //arrange
        when(() => repository.getSelectedRacket()
        ).thenAnswer((_) async => Right( racket ) );
        //act
        final rackets = await repository.getSelectedRacket();
        //assert
        expect(rackets, isA< Right<Err, Racket>>());

      });
      test('failure get selected racke, must return [ RAcketErr]', ()async{
        //arrange
        when(() => repository.getSelectedRacket()
        ).thenAnswer((_ ) async => Left( racketErr )  );
        //act
        final rackets = await repository.getSelectedRacket();
        //assert
        expect(rackets, isA<Left<Err, Racket>>());


      });
    });
    group('remote select racket', (){
      test('success select racket, must return [ Racket ]', ()async{
        
        //arrange
        when(() => repository.selectRacket( racket )
        ).thenAnswer((_) async =>  Right( racket ) );
        //act
        final rackets = await repository.selectRacket( racket );
        //assert
        expect(rackets, isA< Right<Err, Racket>>());

      });
      test('failure select racket, must return [ RAcketErr]', ()async{
        //arrange
        when(() => repository.selectRacket( racket )
        ).thenAnswer((_) async =>Left( racketErr )  );
        //act
        final rackets = await repository.selectRacket( racket );
        //assert
        expect(rackets, isA<Left<Err, Racket>>());


      });
    });
    group('remote deselect racket', (){
      test('success deselect racket, must return [ Racket ]', ()async{
        
        //arrange
        when(() => repository.deselectRacket()
        ).thenAnswer((_) async => Right( null ) );
        //act
        final rackets = await repository.deselectRacket();
        //assert
        expect(rackets, isA< Right<Err, void>>());

      });
      test('failure select racket, must return [ RAcketErr]', ()async{
        //arrange
        when(() => repository.deselectRacket()
        ).thenAnswer((_) async => Left( racketErr )  );
        //act
        final rackets = await repository.deselectRacket();
        //assert
        expect(rackets, isA<Left<Err, void>>());


      });
    });


}