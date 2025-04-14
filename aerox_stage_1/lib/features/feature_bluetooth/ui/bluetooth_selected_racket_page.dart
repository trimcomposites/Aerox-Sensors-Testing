import 'package:aerox_stage_1/common/ui/error_dialog.dart';
import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/domain/models/blob_data_extension.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_rtsos_hs/ui/rtsos_recording_lobby.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/blocs/selected_entity_page/selected_entity_page_bloc.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/blocs/sensors/sensors_bloc.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/ui/ble_record_with_button.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/ui/ble_tester_action_menu.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/ui/selected_racket_name.dart';
import 'package:aerox_stage_1/features/feature_home/ui/home_page_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BluetoothSelectedRacketPage extends StatelessWidget {
  const BluetoothSelectedRacketPage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedEntityPageBloc =
        BlocProvider.of<SelectedEntityPageBloc>(context);
    selectedEntityPageBloc.add(OnGetSelectedRacketSelectedEntityPage());

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                if(selectedEntityPageBloc.state.selectedRacketEntity!=null){
                  Scaffold.of(context).openDrawer();
                }
              },
            ),
          ),
          actions:[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                selectedEntityPageBloc.add(OnDisconnectSelectedRacketSelectedEntityPage());
                Navigator.of(context).pop();
              },
            ),
          ] ,
        ),
        drawer: BleTesterActionMenu(),
        body: BlocListener<SelectedEntityPageBloc, SelectedEntityPageState>(
          listener: (context, state) {
            if (state.selectedRacketEntity == null &&
                state.uiState.status == UIStatus.error) {
              ErrorDialog.showErrorDialog(context, state.uiState.errorMessage);
            }
          },
          child: BlocBuilder<SelectedEntityPageBloc, SelectedEntityPageState>(
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  BlocBuilder<SelectedEntityPageBloc, SelectedEntityPageState>(
                    builder: (context, state) {
                      return Center(
                        child: Column(
                          children: [
                            SelectedRacketName(),
                            BleRecordWithButton( 
                              text: 'Grabación con Cámaras', 
                              color: Colors.red,
                              onPressed: (){ Navigator.pushReplacement(context, MaterialPageRoute(builder: ( context ) => RTSOSRecordingLobby( sampleRate: 1, ))); }, 
                              ),
                            BleRecordWithButton( 
                              text: 'Grabación SIN Cámaras',
                              color: Colors.blue, 
                              onPressed: (){ Navigator.pushReplacement(context, MaterialPageRoute(builder: ( context ) => RTSOSRecordingLobby( sampleRate: 104, ))); }, 
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
