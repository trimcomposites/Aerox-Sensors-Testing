import 'package:aerox_stage_1/features/feature_home/ui/home_page_barrel.dart';

class BleRecordWithButton extends StatelessWidget {
  const BleRecordWithButton({
    super.key, required this.text, this.color, this.onPressed,
  });
    final String text;
  final Color? color;
  final void Function()? onPressed;


  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed, 
      child: Container( 
              width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.08,
        decoration: BoxDecoration( color: color ?? Colors.blue.shade300, borderRadius: BorderRadius.circular(20,),  ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(child: Text( text, style: TextStyle( fontSize: 20, color: Colors.white ), )),
        ),
       )
      );
  }
}
