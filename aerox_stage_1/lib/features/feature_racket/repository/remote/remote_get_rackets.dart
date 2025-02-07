import 'package:aerox_stage_1/common/utils/either_catch.dart';
import 'package:aerox_stage_1/common/utils/error/err/racket_err.dart';
import 'package:aerox_stage_1/common/utils/exceptions/exception.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/domain/models/racket_serializer.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class RemoteGetRackets {

  final baseurl = 'https://aeroxmock-477145875427.europe-southwest1.run.app/';


  Future<List<Racket>> fetchData() async {

      final response = await http.get(Uri.parse(baseurl));

      if (response.statusCode == 200) {
        var data = response.body;
        List<Racket> rackets = RacketSerializer.racketListFromJson(data);
        return rackets;
      } else {
        throw Exception();
      }
    }
}
