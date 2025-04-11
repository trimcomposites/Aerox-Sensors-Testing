part of 'rtsos_lobby_bloc.dart';

class RtsosLobbyState extends Equatable {
  final String? selectedHitType;
  final List<String> hitTypes;

  RtsosLobbyState({
    required this.selectedHitType,
  }): hitTypes =  RTSOSCommonValues.hitTypeDescriptions.keys.toList();

  // Mapa estático: nombre del golpe -> descripción

  // copyWith para actualizar el estado
  RtsosLobbyState copyWith({
    String? selectedHitType,
    List<String>? hitTypes,
  }) {
    return RtsosLobbyState(
      selectedHitType: selectedHitType ?? this.selectedHitType,
    );
  }

  @override
  List<Object?> get props => [selectedHitType, hitTypes];
}
class RTSOSCommonValues {
    static const Map<String, String> hitTypeDescriptions = {
    'D': 'Derecha tras bote: Golpe de derecha después del bote en el suelo.',
    'R': 'Revés tras bote: Golpe de revés después del bote en el suelo.',
    'DP': 'Derecha tras pared: Golpe de derecha después del rebote en la pared.',
    'RW': 'Revés tras pared: Golpe de revés después del rebote en la pared.',
    'DG': 'Globo de derecha: Globo con golpe de derecha.',
    'RG': 'Globo de revés: Globo con golpe de revés.',
    'DGP': 'Globo de derecha tras pared: Globo de derecha tras el rebote en la pared.',
    'RGP': 'Globo de revés tras pared: Globo de revés tras el rebote en la pared.',
    'DV': 'Volea de derecha: Golpe de volea de derecha.',
    'RV': 'Volea de revés: Golpe de volea de revés.',
    'B': 'Bandeja: Golpe intermedio entre una volea y un smash.',
    'S': 'Remate/Smash: Golpe potente de remate.',
    'SE': 'Saque/Servicio: Saque, golpe inicial del punto.',
  };

}