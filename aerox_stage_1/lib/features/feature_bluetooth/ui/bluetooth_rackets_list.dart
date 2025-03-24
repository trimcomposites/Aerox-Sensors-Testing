import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor_entity.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/blocs/sensors/sensors_bloc.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/ui/racket_entity_list_item.dart';
import 'package:aerox_stage_1/features/feature_home/ui/home_page_barrel.dart';
import 'package:aerox_stage_1/features/feature_login/ui/widgets/loading_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothRacketsList extends StatelessWidget {
  const BluetoothRacketsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final sensorsBloc = BlocProvider.of<SensorsBloc>(context);
    sensorsBloc.add(OnStartScanBluetoothSensors());

    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: BlocListener<SensorsBloc, SensorsState>(
        listener: (context, state) {
          if( state.selectedRacketEntity != null && state.uiState.next != null ){
            Navigator.pushNamed(context, state.uiState.next!);
          }
        },
        child: BlocBuilder<SensorsBloc, SensorsState>(
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Dispositivos Encontrados:"),
                SizedBox(height: 10),
                SizedBox(
                  height: 400,
                  child: ListView.builder(
                    itemCount: state.sensors.length,
                    itemBuilder: (BuildContext context, int index1) {
                      final entity = state.sensors[index1];
                      return RacketEntityListItem(
                        entity: entity,
                      );
                    },
                  ),
                ),
                state.uiState.status == UIStatus.loading
                    ? LoadingIndicator()
                    : Container(),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cerrar"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
