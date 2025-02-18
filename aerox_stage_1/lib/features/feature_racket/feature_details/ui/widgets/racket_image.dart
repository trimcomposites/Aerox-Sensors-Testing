import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class RacketImage extends StatelessWidget {
  const RacketImage({
    super.key,
    required this.isRacketSelected,
    required this.racket, required this.height,
  });

  final bool isRacketSelected;
  final Racket racket;
  final double height;

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 600,
      width: 400,
      child: ModelViewer(
        src: 'assets/3d/adidas_padel_2023.glb',
        autoRotate: true,
        interactionPrompt: InteractionPrompt.none,
        ),
      
    );

    // return Image.network(
    //   isRacketSelected ? racket.imagen : racket.imagen,
    //   height: height,
    //   loadingBuilder: (context, child, loadingProgress) {
    //     if (loadingProgress == null) return child; 
    //     return Center(
    //       child: CircularProgressIndicator(
    //         value: loadingProgress.expectedTotalBytes != null
    //             ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
    //             : null,
    //       ),
    //     );
    //   },
    //   errorBuilder: (context, error, stackTrace) {
    //     return Image.asset(
    //       'assets/Pala-Catalogo.png', 
    //       height: height,
          
    //     );
    //   },
    // );
  }
}
