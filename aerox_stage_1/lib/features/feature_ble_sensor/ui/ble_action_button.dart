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
    return Container(
      height: 70,
      decoration: BoxDecoration( 
        color: Colors.amber.shade200,
        border: Border.all( color: Colors.amber, width: 3 ),
        borderRadius: BorderRadius.only( topRight: Radius.circular(20), bottomRight: Radius.circular(20) )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text( text, style: TextStyle( fontSize: 13 )),
          SizedBox(   width: 10, ),
          CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              onPressed: () => {
                selectedEntityPageBloc
                  .add(event)
              },
              icon: Icon(
                icon
              ),
              color: iconColor
            ),
          ),
        ],
      ),
    );
  }
}
