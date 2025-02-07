class Racket {
    int id;
    String golpeo;
    String pala;
    String nombrePala;
    String color;
    String weightNumber;
    String weightName;
    String weightType;
    String balance;
    String headType;
    String swingWeight;
    String potenciaType;
    String acor;
    String acorType;
    String manejabilidad;
    String manejabilidadType;
    String imagen;
    bool isSelected;

    Racket({
        required this.id,
        required this.golpeo,
        required this.pala,
        required this.nombrePala,
        required this.color,
        required this.weightNumber,
        required this.weightName,
        required this.weightType,
        required this.balance,
        required this.headType,
        required this.swingWeight,
        required this.potenciaType,
        required this.acor,
        required this.acorType,
        required this.manejabilidad,
        required this.manejabilidadType,
        required this.imagen,
        this.isSelected = false
    });

    Racket copyWith({
        int? id,
        String? golpeo,
        String? pala,
        String? nombrePala,
        String? color,
        String? weightNumber,
        String? weightName,
        String? weightType,
        String? balance,
        String? headType,
        String? swingWeight,
        String? potenciaType,
        String? acor,
        String? acorType,
        String? manejabilidad,
        String? manejabilidadType,
        String? imagen,
    }) => 
        Racket(
            id: id ?? this.id,
            golpeo: golpeo ?? this.golpeo,
            pala: pala ?? this.pala,
            nombrePala: nombrePala ?? this.nombrePala,
            color: color ?? this.color,
            weightNumber: weightNumber ?? this.weightNumber,
            weightName: weightName ?? this.weightName,
            weightType: weightType ?? this.weightType,
            balance: balance ?? this.balance,
            headType: headType ?? this.headType,
            swingWeight: swingWeight ?? this.swingWeight,
            potenciaType: potenciaType ?? this.potenciaType,
            acor: acor ?? this.acor,
            acorType: acorType ?? this.acorType,
            manejabilidad: manejabilidad ?? this.manejabilidad,
            manejabilidadType: manejabilidadType ?? this.manejabilidadType,
            imagen: imagen ?? this.imagen,
        );
}