import 'package:aerox_stage_1/domain/models/racket_sensor_entity.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/blocs/sensors/sensors_bloc.dart';
import 'package:aerox_stage_1/features/feature_home/ui/home_page_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class RacketEntitySensorList extends StatelessWidget {
  const RacketEntitySensorList({
    super.key,
    required this.entity,
  });

  final RacketSensorEntity entity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        itemCount: entity.sensors.length,
        itemBuilder: (BuildContext context, int index) {
          final sensor = entity.sensors[index];
              return Text('Sensor: ${sensor.id}');
            },
      )
    );
    }
}

