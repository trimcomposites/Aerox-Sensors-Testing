import 'package:aerox_stage_1/features/feature_bluetooth/blocs/selected_entity_page/selected_entity_page_bloc.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/ui/ble_action_button.dart';
import 'package:aerox_stage_1/features/feature_home/ui/home_page_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BleTesterActionMenu extends StatelessWidget {
  const BleTesterActionMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocListener<SelectedEntityPageBloc, SelectedEntityPageState>(
        listener: (context, state) {
          if(state.selectedRacketEntity == null){
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<SelectedEntityPageBloc, SelectedEntityPageState>(
          builder: (context, state) {
            final sensor = state.selectedRacketEntity?.sensors[0];

            return Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  if (sensor != null)
                    Expanded(
                      child: ListView(
                        children: [
                          BleActionButton(
                            text: 'Desconectar Raqueta',
                            icon: Icons.logout_outlined,
                            iconColor: Colors.red,
                            event:
                                OnDisconnectSelectedRacketSelectedEntityPage(),
                          ),
                          BleActionButton(
                            text: 'Iniciar HS Blob',
                            icon: Icons.send,
                            iconColor: Colors.blue,
                            event: OnStartHSBlob(sensor: sensor),
                          ),
                          BleActionButton(
                            text: 'Leer Memoria',
                            icon: Icons.read_more_outlined,
                            iconColor: Colors.green,
                            event: OnReadStorageData(sensor: sensor),
                          ),
                          BleActionButton(
                            text: 'Stream RTSOS',
                            icon: Icons.wifi,
                            iconColor: Colors.yellow,
                            event: OnStartStreamRTSOS(sensor: sensor),
                          ),
                          BleActionButton(
                            text: 'Set Timestamp',
                            icon: Icons.alarm_add,
                            iconColor: Colors.brown,
                            event: OnSetTimeStamp(sensor: sensor),
                          ),
                          BleActionButton(
                            text: 'Get Timestamp',
                            icon: Icons.alarm,
                            iconColor: Colors.purple,
                            event: OnGetTimeStamp(sensor: sensor),
                          ),
                          BleActionButton(
                            text: 'Borrar Memoria',
                            icon: Icons.delete_forever,
                            iconColor: Colors.red,
                            event: OnEraseStorageData(),
                          ),
                        ],
                      ),
                    )
                  else
                    const Center(child: Text("No hay sensor seleccionado")),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
