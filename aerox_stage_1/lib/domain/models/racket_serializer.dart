import 'package:aerox_stage_1/domain/models/racket.dart';
import 'dart:convert';

class RacketSerializer {
  static List<Racket> racketFromJson(String str) => List<Racket>.from(json.decode(str).map((x) => fromJsonRacket(x)));

  static String racketToJson(List<Racket> data) => json.encode(List<dynamic>.from(data.map((x) => toJsonRacket( x ))));

  static Racket fromJsonRacket(Map<String, dynamic> json) => Racket(
      id: json["id"],
      hit: json["hit"],
      racket: json["racket"],
      racketName: json["racketName"],
      color: json["color"],
      weightNumber: json["weightNumber"],
      weightName: json["weightUnit"],
      weightType: json["weightType"],
      balance: json["balance"],
      headType: json["headType"],
      swingWeight: json["swingWeight"],
      powerType: json["powerType"],
      acor: json["acor"],
      acorType: json["acorType"],
      maneuverability: json["maneuverability"],
      maneuverabilityType: json["maneuverabilityType"],
      image: json["image"],
  );

  static Map<String, dynamic> toJsonRacket(Racket racket) => {
      "id": racket.id,
      "hit": racket.hit,
      "racket": racket.racket,
      "racketName": racket.racketName,
      "color": racket.color,
      "weightNumber": racket.weightNumber,
      "weightUnit": racket.weightName,
      "weightType": racket.weightType,
      "balance": racket.balance,
      "headType": racket.headType,
      "swingWeight": racket.swingWeight,
      "powerType": racket.powerType,
      "acor": racket.acor,
      "acorType": racket.acorType,
      "maneuverability": racket.maneuverability,
      "maneuverabilityType": racket.maneuverabilityType,
      "image": racket.image,
  };

  static List<Racket> racketListFromJson(String str) =>
    List<Racket>.from(json.decode(str).map((x) => fromJsonRacket(x)));

  static String racketListToJson(List<Racket> data) =>
    json.encode(List<dynamic>.from(data.map((x) => toJsonRacket(x))));
}
