import 'package:aerox_stage_1/features/feature_bluetooth/blocs/selected_entity_page/selected_entity_page_bloc.dart';
import 'package:aerox_stage_1/features/feature_home/ui/home_page_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BleActionButton extends StatelessWidget {
  const BleActionButton({
    super.key,
    required this.text,
    required this.event,
    required this.icon,
    required this.iconColor,
  });


  final String text;
  final SelectedEntityPageEvent event;
  final IconData icon;
  final Color iconColor;
  @override
  Widget build(BuildContext context) {
    final selectedEntityPageBloc = BlocProvider.of<SelectedEntityPageBloc>(context);
    return Padding(
      padding: const EdgeInsets.only( bottom: 5 ),
      child: InkWell(
          onTap: () => {
            selectedEntityPageBloc
              .add(event)
          },
        child: Container(
          height: 50,
          decoration: BoxDecoration(             
            color: Color.fromARGB(255, 244, 252, 255),
            border: Border.all( color: Colors.blue.shade400, width: 3 ),
            borderRadius: BorderRadius.only( topRight: Radius.circular(20), bottomRight: Radius.circular(20) )
          ),
          child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text( text, style: TextStyle( fontSize: 13 )),
                SizedBox(   width: 10, ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    icon,
                    color: iconColor
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}
