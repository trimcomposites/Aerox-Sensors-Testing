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
  weightNumber: (json["weightNumber"] is String)
      ? double.tryParse(json["weightNumber"]) ?? 0.0
      : json["weightNumber"].toDouble(),
  weightName: json["weightUnit"],
  weightType: json["weightType"],
  balance: (json["balance"] is String)
      ? double.tryParse(json["balance"]) ?? 0.0
      : json["balance"].toDouble(),
  headType: json["headType"],
  swingWeight: (json["swingWeight"] is String)
      ? double.tryParse(json["swingWeight"]) ?? 0.0
      : json["swingWeight"].toDouble(),
  powerType: json["powerType"],
  acor: (json["acor"] is String)
      ? double.tryParse(json["acor"]) ?? 0.0
      : json["acor"].toDouble(),
  acorType: json["acorType"],
  maneuverability: (json["maneuverability"] is String)
      ? double.tryParse(json["maneuverability"]) ?? 0.0
      : json["maneuverability"].toDouble(),
  maneuverabilityType: json["maneuverabilityType"],
  image: json["image"],
  weightMin: (json["weightMin"] is String)
      ? double.tryParse(json["weightMin"]) ?? 0.0
      : json["weightMin"].toDouble(),
  weightMax: (json["weightMax"] is String)
      ? double.tryParse(json["weightMax"]) ?? 0.0
      : json["weightMax"].toDouble(),
  balanceMin: (json["balanceMin"] is String)
      ? double.tryParse(json["balanceMin"]) ?? 0.0
      : json["balanceMin"].toDouble(),
  balanceMax: (json["balanceMax"] is String)
      ? double.tryParse(json["balanceMax"]) ?? 0.0
      : json["balanceMax"].toDouble(),
  swingWeightMin: (json["swingWeightMin"] is String)
      ? double.tryParse(json["swingWeightMin"]) ?? 0.0
      : json["swingWeightMin"].toDouble(),
  swingWeightMax: (json["swingWeightMax"] is String)
      ? double.tryParse(json["swingWeightMax"]) ?? 0.0
      : json["swingWeightMax"].toDouble(),
  maneuverabilityMin: (json["maneuverabilityMin"] is String)
      ? double.tryParse(json["maneuverabilityMin"]) ?? 0.0
      : json["maneuverabilityMin"].toDouble(),
  maneuverabilityMax: (json["maneuverabilityMax"] is String)
      ? double.tryParse(json["maneuverabilityMax"]) ?? 0.0
      : json["maneuverabilityMax"].toDouble(),
  acorMin: (json["acorMin"] is String)
      ? double.tryParse(json["acorMin"]) ?? 0.0
      : json["acorMin"].toDouble(),
  acorMax: (json["acorMax"] is String)
      ? double.tryParse(json["acorMax"]) ?? 0.0
      : json["acorMax"].toDouble(),
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
