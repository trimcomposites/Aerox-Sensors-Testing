
import 'package:aerox_stage_1/common/ui/error_dialog.dart';
import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/blocs/selected_entity_page/selected_entity_page_bloc.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/blocs/sensors/sensors_bloc.dart';
import 'package:aerox_stage_1/features/feature_home/ui/home_page_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BluetoothSelectedRacketPage extends StatelessWidget {
   const BluetoothSelectedRacketPage({super.key});



@override
Widget build(BuildContext context) {
  final selectedEntityPageBloc = BlocProvider.of<SelectedEntityPageBloc>(context);
  selectedEntityPageBloc.add(OnGetSelectedRacketSelectedEntityPage());

  return Scaffold(
    body: BlocListener<SelectedEntityPageBloc, SelectedEntityPageState>(
      listener: (context, state) {
        if (state.selectedRacketEntity == null &&
            state.uiState.status == UIStatus.error ) {
            ErrorDialog.showErrorDialog(context, state.uiState.errorMessage);
        }
      },
        child: BlocBuilder<SelectedEntityPageBloc, SelectedEntityPageState>(
          builder: (context, state) {
            return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, 
                  crossAxisAlignment: CrossAxisAlignment.center, 
                  children: [
                    Text( 'Pala seleccionada:' ),
                    Text(  state.selectedRacketEntity?.name ??
                      'No hay raqueta BLuetooth Seleccionada.'
                    ),
                    IconButton(onPressed: () => {
                        selectedEntityPageBloc.add( OnDisconnectSelectedRacketSelectedEntityPage() )
                      }, 
                      icon: Icon( Icons.logout_outlined,),
                      color: Colors.red,
                    )
                  ],
                ));
          },
        ),
      ),
    );
  }
}
