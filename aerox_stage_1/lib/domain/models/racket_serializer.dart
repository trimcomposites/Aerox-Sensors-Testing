import 'package:aerox_stage_1/domain/models/racket.dart';
import 'dart:convert';

class RacketSerializer {
  static List<Racket> racketFromJson(String str) => List<Racket>.from(json.decode(str).map((x) => fromJsonRacket(x)));

  static String racketToJson(List<Racket> data) => json.encode(List<dynamic>.from(data.map((x) => toJsonRacket( x ))));

  static Racket fromJsonRacket(Map<String, dynamic> json) => Racket(
        id: json["id"],
        golpeo: json["golpeo"],
        pala: json["pala"],
        nombrePala: json["nombrePala"],
        color: json["color"],
        weightNumber: json["weightNumber"],
        weightName: json["weightName"],
        weightType: json["weightType"],
        balance: json["balance"],
        headType: json["headType"],
        swingWeight: json["swingWeight"],
        potenciaType: json["potenciaType"],
        acor: json["acor"],
        acorType: json["acorType"],
        manejabilidad: json["manejabilidad"],
        manejabilidadType: json["manejabilidadType"],
        imagen: json["imagen"],
    );

    static Map<String, dynamic> toJsonRacket( Racket racket ) => {
        "id": racket.id,
        "golpeo": racket.golpeo,
        "pala": racket.pala,
        "nombrePala": racket.nombrePala,
        "color": racket.color,
        "weightNumber": racket.weightNumber,
        "weightName": racket.weightName,
        "weightType": racket.weightType,
        "balance": racket.balance,
        "headType": racket.headType,
        "swingWeight": racket.swingWeight,
        "potenciaType": racket.potenciaType,
        "acor": racket.acor,
        "acorType": racket.acorType,
        "manejabilidad": racket.manejabilidad,
        "manejabilidadType": racket.manejabilidadType,
        "imagen": racket.imagen,
    };

  static List<Racket> racketListFromJson(String str) =>
    List<Racket>.from(json.decode(str).map((x) => fromJsonRacket(x)));

  static String racketListToJson(List<Racket> data) =>
    json.encode(List<dynamic>.from(data.map((x) => toJsonRacket(x))));
}
