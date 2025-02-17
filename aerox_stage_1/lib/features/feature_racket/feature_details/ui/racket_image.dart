import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';

class RacketImage extends StatelessWidget {
  const RacketImage({
    super.key,
    required this.isRacketSelected,
    required this.racket,
  });

  final bool isRacketSelected;
  final Racket racket;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      isRacketSelected ? racket.imagen : racket.imagen,
      height: 450,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child; 
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/Pala-Catalogo.png', 
          height: 450,
          fit: BoxFit.cover,
        );
      },
    );
  }
}
