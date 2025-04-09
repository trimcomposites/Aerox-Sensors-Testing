import 'package:aerox_stage_1/common/ui/error_dialog.dart';
import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/domain/models/blob_data_extension.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/blocs/selected_entity_page/selected_entity_page_bloc.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/blocs/sensors/sensors_bloc.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/ui/ble_tester_action_menu.dart';
import 'package:aerox_stage_1/features/feature_home/ui/home_page_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BluetoothSelectedRacketPage extends StatelessWidget {
  const BluetoothSelectedRacketPage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedEntityPageBloc =
        BlocProvider.of<SelectedEntityPageBloc>(context);
    selectedEntityPageBloc.add(OnGetSelectedRacketSelectedEntityPage());

    return Scaffold(
      body: BlocListener<SelectedEntityPageBloc, SelectedEntityPageState>(
        listener: (context, state) {
          if (state.selectedRacketEntity == null &&
              state.uiState.status == UIStatus.error) {
            ErrorDialog.showErrorDialog(context, state.uiState.errorMessage);
          }
        },
        child: BlocBuilder<SelectedEntityPageBloc, SelectedEntityPageState>(
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BleTesterActionMenu(),
                BlocBuilder<SelectedEntityPageBloc, SelectedEntityPageState>(
                  builder: (context, state) {
                    return Container(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        itemCount: state.blobs.length,
                        itemBuilder: (BuildContext context, int index) {
                          final blob = state.blobs[index];
                         // final parsed = blob.parseHs1kHzBlob();
                          return Row(
                            children: [
                              SingleChildScrollView( scrollDirection: Axis.horizontal,  child: Container(child: Text("blob ${ blob.createdAt }", maxLines: 10,))),
                              IconButton(onPressed: () {
                                selectedEntityPageBloc.add( OnParseBlob(blob: blob) );
                              }, icon: Icon( Icons.arrow_circle_up )
                              )
                            ],
                          );
                          
                        },
                      ),

                    );
                  },
                )
              ],
            ));
          },
        ),
      ),
    );
  }
}
