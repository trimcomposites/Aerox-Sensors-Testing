part of 'rtsos_lobby_bloc.dart';

class RtsosLobbyState extends Equatable {
  final UIState uiState;
  final String? selectedHitType;
  final List<String> hitTypes;
  final int durationSeconds;
  final RacketSensorEntity? sensorEntity;
  final int recordedBlobCounter; 
  final bool isRecording; 
  final SampleRate sampleRate;
  RtsosLobbyState({
    required this.uiState,
    required this.selectedHitType,
    this.durationSeconds = 5,
    this.sensorEntity,
    this.recordedBlobCounter = 0,
    this.isRecording = false,
    this.sampleRate = SampleRate.hz104
  }) : hitTypes = RTSOSCommonValues.hitTypeDescriptions.keys.toList();

  RtsosLobbyState copyWith({
    UIState? uiState,
    String? selectedHitType,
    List<String>? hitTypes,
    int? durationSeconds,
    RacketSensorEntity? sensorEntity,
    int? recordedBlobCounter,
    bool? isRecording,
    SampleRate? sampleRate
  }) {
    return RtsosLobbyState(
      uiState: uiState ?? this.uiState,
      selectedHitType: selectedHitType ?? this.selectedHitType,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      sensorEntity: sensorEntity ?? this.sensorEntity,
      recordedBlobCounter: recordedBlobCounter ?? this.recordedBlobCounter,
      isRecording: isRecording ?? this.isRecording,
      sampleRate: sampleRate ?? this.sampleRate
    );
  }

  @override
  List<Object?> get props => [
        uiState,
        selectedHitType,
        hitTypes,
        durationSeconds,
        sensorEntity,
        recordedBlobCounter,
        isRecording,
        sampleRate
      ];
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