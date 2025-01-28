import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';

class TopNotchPadding extends StatelessWidget {
  const TopNotchPadding({super.key, required this.context, this.child});
  final BuildContext context;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
                color: backgroundColor,
      child: Padding( 
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top
        ),
        child: child,
      ),
    );
  }
}