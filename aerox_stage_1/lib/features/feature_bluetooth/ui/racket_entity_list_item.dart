import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor_entity.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/blocs/sensors/sensors_bloc.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/ui/bluetooth_rackets_list.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/ui/connecting_sensors_dialog.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/ui/racket_entity_sensor_list.dart';
import 'package:aerox_stage_1/features/feature_home/ui/home_page_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RacketEntityListItem extends StatelessWidget {
  const RacketEntityListItem({
    super.key,
    required this.entity,
  });

  final RacketSensorEntity entity;

  @override
  Widget build(BuildContext context) {
    final sensorsBloc = BlocProvider.of<SensorsBloc>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
          TextButton.icon(
              onPressed: () {
                if( sensorsBloc.state.uiState.status != UIStatus.loading ){
                  sensorsBloc.add(OnConnectRacketSensorEntity(id: entity.id));
                }
              
              },
              icon: Icon(Icons.sports_tennis_outlined),
              label: Text( entity.name ),
            ),
          ]
        ),
        SizedBox(height: 5),
        RacketEntitySensorList( entity: entity ),
        Divider(),
      ],
    );
  }



}
