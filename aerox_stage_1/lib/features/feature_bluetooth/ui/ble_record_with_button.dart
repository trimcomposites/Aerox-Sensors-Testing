import 'package:aerox_stage_1/features/feature_home/ui/home_page_barrel.dart';

class BleRecordWithButton extends StatelessWidget {
  const BleRecordWithButton({
    super.key, required this.text, required this.color, this.onPressed,
  });
    final String text;
  final Color color;
  final void Function()? onPressed;


  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed, 
      child: Container( 
        decoration: BoxDecoration( color: color, borderRadius: BorderRadius.circular(20,),  ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text( text, style: TextStyle( fontSize: 25, color: Colors.white ), ),
        ),
       )
      );
  }
}
