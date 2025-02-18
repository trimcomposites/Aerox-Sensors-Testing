import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/domain/models/spec.dart';

extension RacketExtension on Racket{
  List<Spec>getSpecs(){
    return [
      Spec(key: 'Marco', value: this.pala),
      Spec(key: 'Golpeo', value: this.golpeo),
      Spec(key: 'Marco Reforzado', value: this.nombrePala),
      Spec(key: 'Rugosidad', value: this.pala),
      Spec(key: 'Foam', value: this.acor),
      Spec(key: 'Nucleo', value: this.nombrePala),
      Spec(key: 'Carbon Fibre', value: this.color),
      Spec(key: 'Tacto', value: this.potenciaType),

    ];
  }
}
