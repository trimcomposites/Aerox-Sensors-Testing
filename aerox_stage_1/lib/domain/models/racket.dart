import 'package:aerox_stage_1/domain/models/spec.dart';

class Racket {
  int id;
  String  docId;
  String hit;
  String frame;
  String racketName;
  String color;
  double weightNumber;
  String weightName;
  String weightType;
  double balance;
  String headType;
  double swingWeight;
  String powerType;
  double acor;
  String acorType;
  double maneuverability;
  String maneuverabilityType;
  String image;
  bool isSelected;
  double weightMin;
  double weightMax;
  double balanceMin;
  double balanceMax;
  double swingWeightMin;
  double swingWeightMax;
  double maneuverabilityMin;
  double maneuverabilityMax;
  double acorMin;
  double acorMax;
  String model;

  Racket({
    required this.id,
    this.docId = '',
    required this.hit,
    required this.frame,
    required this.racketName,
    required this.color,
    required this.weightNumber,
    required this.weightName,
    required this.weightType,
    required this.balance,
    required this.headType,
    required this.swingWeight,
    required this.powerType,
    required this.acor,
    required this.acorType,
    required this.maneuverability,
    required this.maneuverabilityType,
    required this.image,
    required this.weightMin,
    required this.weightMax,
    required this.balanceMin,
    required this.balanceMax,
    required this.swingWeightMin,
    required this.swingWeightMax,
    required this.maneuverabilityMin,
    required this.maneuverabilityMax,
    required this.acorMin,
    required this.acorMax,
    required this.model,
    this.isSelected = false,
  });

  Racket copyWith({
    int? id,
    String? hit,
    String? racket,
    String? racketName,
    String? color,
    double? weightNumber,
    String? weightName,
    String? weightType,
    double? balance,
    String? headType,
    double? swingWeight,
    String? powerType,
    double? acor,
    String? acorType,
    double? maneuverability,
    String? maneuverabilityType,
    String? image,
    bool? isSelected,
    double? weightMin,
    double? weightMax,
    double? balanceMin,
    double? balanceMax,
    double? swingWeightMin,
    double? swingWeightMax,
    double? maneuverabilityMin,
    double? maneuverabilityMax,
    double? acorMin,
    double? acorMax,
    String? model
  }) =>
      Racket(
        id: id ?? this.id,
        hit: hit ?? this.hit,
        frame: racket ?? this.frame,
        racketName: racketName ?? this.racketName,
        color: color ?? this.color,
        weightNumber: weightNumber ?? this.weightNumber,
        weightName: weightName ?? this.weightName,
        weightType: weightType ?? this.weightType,
        balance: balance ?? this.balance,
        headType: headType ?? this.headType,
        swingWeight: swingWeight ?? this.swingWeight,
        powerType: powerType ?? this.powerType,
        acor: acor ?? this.acor,
        acorType: acorType ?? this.acorType,
        maneuverability: maneuverability ?? this.maneuverability,
        maneuverabilityType: maneuverabilityType ?? this.maneuverabilityType,
        image: image ?? this.image,
        isSelected: isSelected ?? this.isSelected,
        weightMin: weightMin ?? this.weightMin,
        weightMax: weightMax ?? this.weightMax,
        balanceMin: balanceMin ?? this.balanceMin,
        balanceMax: balanceMax ?? this.balanceMax,
        swingWeightMin: swingWeightMin ?? this.swingWeightMin,
        swingWeightMax: swingWeightMax ?? this.swingWeightMax,
        maneuverabilityMin: maneuverabilityMin ?? this.maneuverabilityMin,
        maneuverabilityMax: maneuverabilityMax ?? this.maneuverabilityMax,
        acorMin: acorMin ?? this.acorMin,
        acorMax: acorMax ?? this.acorMax,
        model: model ?? this.model,
      );


}
