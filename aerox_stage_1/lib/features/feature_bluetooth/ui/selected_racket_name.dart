import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_rtsos_hs/blocs/rtsos_lobby/rtsos_lobby_bloc.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/blocs/selected_entity_page/selected_entity_page_bloc.dart';
import 'package:aerox_stage_1/features/feature_home/ui/home_page_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedRacketName extends StatelessWidget {
  const SelectedRacketName({
    super.key,
    this.showStorage = false,
  });

  final bool showStorage;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectedEntityPageBloc, SelectedEntityPageState>(
      builder: (context, state) {
        final sensors = state.selectedRacketEntity?.sensors ?? [];

        return Container(
          padding: const EdgeInsets.all(12),
          height: sensors.length > 1 ? 300 : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state.selectedRacketEntity != null)
                const Text(
                  'Pala seleccionada:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              Row(
                children: [
                  Text(
                    state.selectedRacketEntity?.name ??
                        'No hay raqueta seleccionada',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.storage,
                    color: Colors.blue.shade400,
                  )
                ],
              ),
              const SizedBox(height: 12),

              if (sensors.length == 1)
                _buildLargeSensorCard(context, sensors.first)
              else if (sensors.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: sensors.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return _buildSensorTile(
                        context,
                        sensors[index],
                        index,
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLargeSensorCard(BuildContext context, RacketSensor sensor) {
    return BlocBuilder<RtsosLobbyBloc, RtsosLobbyState>(
      builder: (context, state) {
        final blobStatus = state.sensorEntity?.sensors.first.numBlobs?.values.first;
        final blobKey = state.sensorEntity?.sensors.first.numBlobs?.keys.first.toString();

        return Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade100, width: 1),
          ),
          child: Row(
            children: [
              Icon(Icons.sensors, size: 32, color: Colors.blue),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(sensor.id, style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.battery_0_bar, size: 18),
                        const SizedBox(width: 4),
                        Text(sensor.batteryLevel != null
                            ? '${sensor.batteryLevel}%'
                            : 'Sin batería'),
                        const Spacer(),
                        if (showStorage && blobStatus != null)
                          Row(
                            children: [
                              Icon(
                                _getIconForStatus(blobStatus),
                                color: _getColorForStatus(blobStatus),
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Text(blobKey ?? '', style: TextStyle(
                                fontSize: 25
                              ), )
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSensorTile(BuildContext context, RacketSensor sensor, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.sensors, size: 20, color: Colors.blue),
          const SizedBox(width: 8),
          Text(
            sensor.id,
            style: TextStyle(fontSize: showStorage ? 10 : null),
          ),
          const SizedBox(width: 20),
          const Icon(Icons.battery_0_bar, size: 18, color: Colors.black),
          sensor.batteryLevel != null
              ? Text('${sensor.batteryLevel}%')
              : const SizedBox(),
          const Spacer(),
          if (showStorage)
            BlocBuilder<RtsosLobbyBloc, RtsosLobbyState>(
              builder: (context, state) {
                final status = state.sensorEntity?.sensors[index].numBlobs?.values.first;
                final label = state.sensorEntity?.sensors[index].numBlobs?.keys.first.toString() ?? 'error';

                return Row(
                  children: [
                    Icon(
                      _getIconForStatus(status),
                      color: _getColorForStatus(status),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(label),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  IconData _getIconForStatus(BlobCheckStatus? status) {
    switch (status) {
      case BlobCheckStatus.ok:
        return Icons.check_circle;
      case BlobCheckStatus.mismatch:
        return Icons.warning;
      case BlobCheckStatus.failed:
        return Icons.error;
      default:
        return Icons.help_outline;
    }
  }

  Color _getColorForStatus(BlobCheckStatus? status) {
    switch (status) {
      case BlobCheckStatus.ok:
        return Colors.green;
      case BlobCheckStatus.mismatch:
        return Colors.amber;
      case BlobCheckStatus.failed:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
