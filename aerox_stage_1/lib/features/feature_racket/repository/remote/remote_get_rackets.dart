import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/domain/models/racket_serializer.dart';
import 'package:http/http.dart' as http;

class RemoteGetRackets {

  final baseurl = 'https://aerox-api-477145875427.europe-southwest1.run.app/rackets';


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
