import 'package:aerox_stage_1/domain/models/racket.dart';
import 'dart:convert';


class RacketSerializer {
  static List<Racket> racketFromJson(String str) => List<Racket>.from(json.decode(str).map((x) => fromJsonRacket(x)));

  static String racketToJson(List<Racket> data) => json.encode(List<dynamic>.from(data.map((x) => toJsonRacket( x ))));

  static Racket fromJsonRacket(Map<String, dynamic> json) => Racket(
    
    id: json["id"],
    hit: json["hit"],
    frame: json["racket"],
    racketName: json["racketName"],
    color: json["color"],
    weightNumber: (json["weightNumber"] is String)
        ? double.tryParse(json["weightNumber"]) ?? 0.0
        : json["weightNumber"]?.toDouble() ?? 0.0,
    weightName: json["weightUnit"],
    weightType: json["weightType"],
    balance: (json["balance"] is String)
        ? double.tryParse(json["balance"]) ?? 0.0
        : json["balance"]?.toDouble() ?? 0.0,
    headType: json["headType"],
    swingWeight: (json["swingWeight"] is String)
        ? double.tryParse(json["swingWeight"]) ?? 0.0
        : json["swingWeight"]?.toDouble() ?? 0.0,
    powerType: json["powerType"],
    acor: (json["acor"] is String)
        ? double.tryParse(json["acor"]) ?? 0.0
        : json["acor"]?.toDouble() ?? 0.0,
    acorType: json["acorType"],
    maneuverability: (json["maneuverability"] is String)
        ? double.tryParse(json["maneuverability"]) ?? 0.0
        : json["maneuverability"]?.toDouble() ?? 0.0,
    maneuverabilityType: json["maneuverabilityType"],
    image: json["image"],
    weightMin: (json["weightMin"] is String)
        ? double.tryParse(json["weightMin"]) ?? 0.0
        : json["weightMin"]?.toDouble() ?? 0.0,
    weightMax: (json["weightMax"] is String)
        ? double.tryParse(json["weightMax"]) ?? 0.0
        : json["weightMax"]?.toDouble() ?? 0.0,
    balanceMin: (json["balanceMin"] is String)
        ? double.tryParse(json["balanceMin"]) ?? 0.0
        : json["balanceMin"]?.toDouble() ?? 0.0,
    balanceMax: (json["balanceMax"] is String)
        ? double.tryParse(json["balanceMax"]) ?? 0.0
        : json["balanceMax"]?.toDouble() ?? 0.0,
    swingWeightMin: (json["swingWeightMin"] is String)
        ? double.tryParse(json["swingWeightMin"]) ?? 0.0
        : json["swingWeightMin"]?.toDouble() ?? 0.0,
    swingWeightMax: (json["swingWeightMax"] is String)
        ? double.tryParse(json["swingWeightMax"]) ?? 0.0
        : json["swingWeightMax"]?.toDouble() ?? 0.0,
    maneuverabilityMin: (json["maneuverabilityMin"] is String)
        ? double.tryParse(json["maneuverabilityMin"]) ?? 0.0
        : json["maneuverabilityMin"]?.toDouble() ?? 0.0,
    maneuverabilityMax: (json["maneuverabilityMax"] is String)
        ? double.tryParse(json["maneuverabilityMax"]) ?? 0.0
        : json["maneuverabilityMax"]?.toDouble() ?? 0.0,
    acorMin: (json["acorMin"] is String)
        ? double.tryParse(json["acorMin"]) ?? 0.0
        : json["acorMin"]?.toDouble() ?? 0.0,
    acorMax: (json["acorMax"] is String)
        ? double.tryParse(json["acorMax"]) ?? 0.0
        : json["acorMax"]?.toDouble() ?? 0.0,
  );

  static Map<String, dynamic> toJsonRacket(Racket racket) => {
    "id": racket.id,
    "hit": racket.hit,
    "racket": racket.frame,
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
    "weightMin": racket.weightMin,
    "weightMax": racket.weightMax,
    "balanceMin": racket.balanceMin,
    "balanceMax": racket.balanceMax,
    "swingWeightMin": racket.swingWeightMin,
    "swingWeightMax": racket.swingWeightMax,
    "maneuverabilityMin": racket.maneuverabilityMin,
    "maneuverabilityMax": racket.maneuverabilityMax,
    "acorMin": racket.acorMin,
    "acorMax": racket.acorMax,
  };

static List<Racket> racketListFromJson(String str) {
  final Map<String, dynamic> decoded = json.decode(str);  // Decodifica como un Map
  final List<dynamic> racketList = decoded['rackets'];   // Obtén la lista de la clave 'rackets'
  
  // Convierte la lista de objetos a una lista de Racket
  return racketList.map<Racket>((x) => fromJsonRacket(x)).toList();
}


  static String racketListToJson(List<Racket> data) =>
    json.encode(List<dynamic>.from(data.map((x) => toJsonRacket(x))));
}
