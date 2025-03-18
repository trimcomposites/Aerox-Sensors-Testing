import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:aerox_stage_1/features/feature_details/ui/widgets/specs_data_text.dart';

class TechnicalSpecsSheet extends StatelessWidget {
  const TechnicalSpecsSheet({
    super.key,
    required this.rackets, required this.racketIndex,
  });

  final List<Racket> rackets;
  final int racketIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all( color: Colors.black, width: 1 ),
        borderRadius: BorderRadius.circular(15)
      ),
      height: MediaQuery.of(context).size.width/2,
      child: Container(
        padding: EdgeInsets.symmetric( 
          horizontal: 15,
          vertical: 20  
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text( 'Ficha técnica', style: TextStyle(
              fontSize: 11
            ), ),
            SizedBox( height: 10,  ),
            SpecsDataText( text: 'Weight', value: rackets[racketIndex].weightNumber, min: rackets[racketIndex].weightMin, max: rackets[racketIndex].weightMax ),
            SpecsDataText( text: 'Balance', value: rackets[racketIndex].balance, min: rackets[racketIndex].balanceMin, max: rackets[racketIndex].balanceMax),
            SpecsDataText( text: 'Swing Weight',  value: rackets[racketIndex].swingWeight,  min: rackets[racketIndex].swingWeightMin, max: rackets[racketIndex].swingWeightMax ),
            SpecsDataText( text: 'ACOR',  value: rackets[racketIndex].acor,  min: rackets[racketIndex].acorMin, max: rackets[racketIndex].acorMax ),
            SpecsDataText( text: 'Manejabilidad',  value: rackets[racketIndex].maneuverability,  min: rackets[racketIndex].maneuverabilityMin, max: rackets[racketIndex].maneuverabilityMax ),
          ],
        ),
      ),
    );
  }
}
