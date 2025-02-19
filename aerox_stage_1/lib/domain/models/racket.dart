import 'package:aerox_stage_1/domain/models/spec.dart';

class Racket {
    int id;
    String hit;
    String racket;
    String racketName;
    String color;
    String weightNumber;
    String weightName;
    String weightType;
    String balance;
    String headType;
    String swingWeight;
    String powerType;
    String acor;
    String acorType;
    String maneuverability;
    String maneuverabilityType;
    String image;
    bool isSelected;

    Racket({
        required this.id,
        required this.hit,
        required this.racket,
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
        this.isSelected = false
    });
    Racket copyWith({
        int? id,
        String? hit,
        String? racket,
        String? racketName,
        String? color,
        String? weightNumber,
        String? weightName,
        String? weightType,
        String? balance,
        String? headType,
        String? swingWeight,
        String? powerType,
        String? acor,
        String? acorType,
        String? maneuverability,
        String? maneuverabilityType,
        String? image,
        bool? isSelected,
    }) => 
        Racket(
            id: id ?? this.id,
            hit: hit ?? this.hit,
            racket: racket ?? this.racket,
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
        );

}
