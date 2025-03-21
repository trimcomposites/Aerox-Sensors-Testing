import 'package:aerox_stage_1/domain/models/racket_sensor_entity.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/blocs/sensors/sensors_bloc.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/ui/bluetooth_rackets_list.dart';
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
                sensorsBloc.add(OnConnectRacketSensorEntity(id: entity.id));
                showCustomDialog(context);
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
  void showCustomDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Impide que el usuario lo cierre tocando fuera
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Mensaje Importante'),
        content: Text('Este es un diálogo modal que no se puede cerrar.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Aceptar'),
          ),
        ],
      );
    },
  );
}
}
