import 'package:aerox_stage_1/features/feature_bluetooth/blocs/selected_entity_page/selected_entity_page_bloc.dart';
import 'package:aerox_stage_1/features/feature_home/ui/home_page_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BleTesterActionMenu extends StatelessWidget {
  const BleTesterActionMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final selectedEntityPageBloc = BlocProvider.of<SelectedEntityPageBloc>(context);
    return BlocBuilder<SelectedEntityPageBloc, SelectedEntityPageState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Pala seleccionada:'),
            Text(state.selectedRacketEntity?.name ??
                'No hay raqueta BLuetooth Seleccionada.'),
            Text(state.selectedRacketEntity?.sensors[0].name ??
                'No hay raqueta BLuetooth Seleccionada.'),
            Row(
              children: [
                IconButton(
                  onPressed: () => {
                    selectedEntityPageBloc
                        .add(OnDisconnectSelectedRacketSelectedEntityPage())
                  },
                  icon: Icon(
                    Icons.logout_outlined,
                  ),
                  color: Colors.red,
                ),
                IconButton(
                  onPressed: () => {
                    selectedEntityPageBloc.add(OnStartHSBlob(
                        sensor: state.selectedRacketEntity!.sensors[0]))
                  },
                  icon: Icon(
                    Icons.send,
                  ),
                  color: Colors.blue,
                ),
                IconButton(
                  onPressed: () => {
                    selectedEntityPageBloc.add(OnReadStorageData(
                        sensor: state.selectedRacketEntity!.sensors[0]))
                  },
                  icon: Icon(
                    Icons.read_more_outlined,
                  ),
                  color: Colors.green,
                ),
                IconButton(
                  onPressed: () => {
                    selectedEntityPageBloc.add(OnStartStreamRTSOS(
                        sensor: state.selectedRacketEntity!.sensors[0]))
                  },
                  icon: Icon(
                    Icons.wifi,
                  ),
                  color: Colors.yellow,
                ),
              ],
            ),
            
          ],
        );
      },
    );
  }
}
