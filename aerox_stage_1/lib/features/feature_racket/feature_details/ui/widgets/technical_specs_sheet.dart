import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:aerox_stage_1/features/feature_racket/feature_details/ui/widgets/specs_data_text.dart';

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
      width: 350,
      height: 225,
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
    
            SpecsDataText( text: 'Weight', value: rackets[racketIndex].weightNumber, ),
            SpecsDataText( text: 'Balance', value: rackets[racketIndex].balance, ),
            SpecsDataText( text: 'Swing Weight',  value: rackets[racketIndex].swingWeight, ),
            SpecsDataText( text: 'ACOR',  value: rackets[racketIndex].acor, ),
            SpecsDataText( text: 'Manejabilidad',  value: rackets[racketIndex].manejabilidad, ),
          ],
        ),
      ),
    );
  }
}
