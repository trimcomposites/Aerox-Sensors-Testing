import 'package:aerox_stage_1/common/ui/error_dialog.dart';
import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/domain/models/blob_data_extension.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor_entity.dart';
import 'package:aerox_stage_1/domain/use_cases/ble_sensor/start_offline_rtsos_usecase.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_blob_database/ui/blob_database_page.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_rtsos_hs/ui/rtsos_recording_lobby.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/blocs/selected_entity_page/selected_entity_page_bloc.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/blocs/sensors/sensors_bloc.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/ui/ble_record_with_button.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_ble_storage/ui/ble_storage_page.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/ui/ble_tester_action_menu.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_ble_storage/ui/blob_storage_list.dart';
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

    return BlocListener<SelectedEntityPageBloc, SelectedEntityPageState>(
      listener: (context, state) {
        if(state.selectedRacketEntity != null){
          for( var sensor in state.selectedRacketEntity!.sensors ){
            selectedEntityPageBloc.add(OnSetTimeStamp(sensor: sensor));
          }
        }
        if(state.uiState.status == UIStatus.error){
          ErrorDialog.showErrorDialog(context, state.uiState.errorMessage );
        }
      },
      child: PopScope(
          canPop: false,
          child: Scaffold(
            backgroundColor: Color.fromARGB(255, 225, 245, 255),
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
                                  onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: ( context ) => RTSOSRecordingLobby( sampleRate: SampleRate.khz1, ))); }, 
                                  ),
                                BleRecordWithButton( 
                                  text: 'Grabación SIN Cámaras',
                                  onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: ( context ) => RTSOSRecordingLobby( sampleRate: SampleRate.hz104, ))); }, 
                                ),
                                BleRecordWithButton( 
                                  text: 'Leer Memoria de Sensor',
      
                                  onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: ( context ) => BleStoragePage())); }, 
                                ),
                                BleRecordWithButton( 
                                  text: 'Blob Database',
                                  onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: ( context ) => BlobDatabasePage())); }, 
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
        ),
    );
  }
}
