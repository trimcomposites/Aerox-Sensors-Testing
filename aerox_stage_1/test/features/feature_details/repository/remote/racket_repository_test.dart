import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/common/utils/error/err/racket_err.dart';
import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/features/feature_racket/repository/remote/mock_racket_datasource.dart';
import 'package:aerox_stage_1/features/feature_racket/repository/remote/racket_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mock_types.dart';


void main() {
  late MockRacketDatasource datasource;
  late RacketRepository repository;
  setUp((){
    datasource = MockMockRacketDataSource();
    repository = RacketRepository(datasource: datasource);
    
  });

  const List<Racket> mockRackets = [];
  final Racket racket = Racket(id: 1, name: 'name', length: 1, weight: 1, img: '' , pattern: '', balance: 1);
  final RacketErr racketErr = RacketErr(errMsg: 'errMsg', statusCode: 1);

    group('remote get rackets', (){
      test('success get rackets, must return [ List<Racket> ]', ()async{
        
        //arrange
        when(() => datasource.remotegetRackets()
        ).thenAnswer( ( _ ) async => Right( mockRackets ) );
        //act
        final rackets = await repository.getRackets( remote: true );
        //assert
        expect(rackets, isA< Right<Err, List<Racket>>>());

      });
      test('failure get rackets, must return [ RAcketErr]', ()async{
        //arrange
        when(() => datasource.remotegetRackets()
        ).thenAnswer( ( _ ) async => Left( racketErr )  );
        //act
        final rackets = await repository.getRackets( remote: true );
        //assert
        expect(rackets, isA< Left<Err, List<Racket>>>());


      });
    });
    group('remote get selected racket', (){
      test('success get selected racket, must return [ Racket ]', ()async{
        
        //arrange
        when(() => datasource.getSelectedRacket()
        ).thenReturn( Right( racket ) );
        //act
        final rackets = await repository.getSelectedRacket();
        //assert
        expect(rackets, isA< Right<Err, Racket>>());

      });
      test('failure get selected racke, must return [ RAcketErr]', ()async{
        //arrange
        when(() => datasource.getSelectedRacket()
        ).thenReturn( Left( racketErr )  );
        //act
        final rackets = await repository.getSelectedRacket();
        //assert
        expect(rackets, isA<Left<Err, Racket>>());


      });
    });
    group('remote select racket', (){
      test('success select racket, must return [ Racket ]', ()async{
        
        //arrange
        when(() => datasource.selectRacket( racket )
        ).thenReturn( Right( racket ) );
        //act
        final rackets = await repository.selectRacket( racket );
        //assert
        expect(rackets, isA< Right<Err, Racket>>());

      });
      test('failure select racket, must return [ RAcketErr]', ()async{
        //arrange
        when(() => datasource.selectRacket( racket )
        ).thenReturn( Left( racketErr )  );
        //act
        final rackets = await repository.selectRacket( racket );
        //assert
        expect(rackets, isA<Left<Err, Racket>>());


      });
    });
    group('remote deselect racket', (){
      test('success deselect racket, must return [ Racket ]', ()async{
        
        //arrange
        when(() => datasource.deselectRacket()
        ).thenReturn( Right( null ) );
        //act
        final rackets = await repository.deselectRacket();
        //assert
        expect(rackets, isA< Right<Err, void>>());

      });
      test('failure select racket, must return [ RAcketErr]', ()async{
        //arrange
        when(() => datasource.deselectRacket()
        ).thenReturn( Left( racketErr )  );
        //act
        final rackets = await repository.deselectRacket();
        //assert
        expect(rackets, isA<Left<Err, void>>());


      });
    });


}