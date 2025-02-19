import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class Racket3dModel extends StatelessWidget {
  const Racket3dModel({
    super.key,
    required this.isRacketSelected,
    required this.racket, required this.height, required this.ignorePointer, required this.rotateSpeed,
  });


  final bool isRacketSelected;
  final Racket racket;
  final double height;
  final bool ignorePointer;
  final int rotateSpeed;


  @override
  Widget build(BuildContext context) {
    return  IgnorePointer(
      ignoring: ignorePointer,
      child: Container(
        height: 600,
        width: 400,
        child: ModelViewer(
          src: 'assets/3d/adidas_padel_2023.glb',
          autoRotate: true,
          interactionPrompt: InteractionPrompt.none,
          rotationPerSecond: "${rotateSpeed}deg",
          loading: Loading.eager,
          ),
        
      ),
    );
  }
}
