import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:aerox_stage_1/features/feature_details/ui/widgets/expansion_spec_data.dart';
import 'package:aerox_stage_1/features/feature_details/ui/widgets/specs_data_text.dart';
import 'package:aerox_stage_1/features/feature_details/ui/widgets/technical_specs_sheet.dart';

class RacketSpecs extends StatelessWidget {
  const RacketSpecs({
    super.key,
    required this.racketIndexNotifier, required this.rackets, required this.showAdvancedSpecs,
  });

  final ValueNotifier<int> racketIndexNotifier;
  final List<Racket> rackets;
  final bool showAdvancedSpecs;
  
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: racketIndexNotifier,
      builder: (context, racketIndex, child) {
        return Column(
          children: [
            TechnicalSpecsSheet(rackets: rackets, racketIndex: racketIndex,),
            SizedBox( height: 25, ),
            if(showAdvancedSpecs) ExpansionSpecData( racket: rackets[racketIndex], text: 'Características del prodcuto', ),
            if(showAdvancedSpecs) ExpansionSpecData( racket: rackets[racketIndex], text: 'Datos en bruto', )
        ],
      );
      }
    );
  }
}
