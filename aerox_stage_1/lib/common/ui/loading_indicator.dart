import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key, this.showBackGround = true,
  });
  final bool showBackGround;
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: showBackGround ?
          Colors.black.withAlpha(128)
          : Colors.transparent,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}