import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/domain/models/spec.dart';

extension RacketExtension on Racket{
  List<Spec>getSpecs(){
    return [
      Spec(key: 'Marco', value: this.racket),
      Spec(key: 'Golpeo', value: this.hit),
      Spec(key: 'Marco Reforzado', value: this.racketName),
      Spec(key: 'Rugosidad', value: this.racket),
      Spec(key: 'Foam', value: this.acor.toString()),
      Spec(key: 'Nucleo', value: this.racketName),
      Spec(key: 'Carbon Fibre', value: this.color),
      Spec(key: 'Tacto', value: this.powerType),

    ];
  }
}
