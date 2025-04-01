
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
                    Text(  state.selectedRacketEntity?.sensors[0].name ??
                      'No hay raqueta BLuetooth Seleccionada.'
                    ),
                    IconButton(onPressed: () => {
                        selectedEntityPageBloc.add( OnDisconnectSelectedRacketSelectedEntityPage() )
                      }, 
                      icon: Icon( Icons.logout_outlined,),
                      color: Colors.red,
                    ),
                    Text('Desconectar Pala'),
                    IconButton(onPressed: () => {
                        selectedEntityPageBloc.add( OnStartHSBlob( sensor: state.selectedRacketEntity!.sensors[0] ) )
                      }, 
                      icon: Icon( Icons.send,),
                      color: Colors.blue,
                    ),
                    Text('Start Offline RTSOS'),
                    IconButton(onPressed: () => {
                        selectedEntityPageBloc.add( OnReadStorageData( sensor: state.selectedRacketEntity!.sensors[0] ) )
                      }, 
                      icon: Icon( Icons.read_more_outlined,),
                      color: Colors.green,
                    ),
                    Text('Read storage data'),
                    IconButton(onPressed: () => {
                        selectedEntityPageBloc.add( OnStartStreamRTSOS( sensor: state.selectedRacketEntity!.sensors[0] ) )
                      }, 
                      icon: Icon( Icons.wifi,),
                      color: Colors.yellow,
                    ),
                    Text('STREAM RTSOS'),
                  ],
                ));
          },
        ),
      ),
    );
  }
}
