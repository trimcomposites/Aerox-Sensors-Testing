import 'dart:async';
import 'package:aerox_stage_1/common/ui/loading_indicator.dart';
import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor_entity.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/blocs/sensors/sensors_bloc.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/ui/racket_entity_list_item.dart';
import 'package:aerox_stage_1/features/feature_home/ui/home_page_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter/scheduler.dart';

class BluetoothRacketsList extends StatelessWidget {
  const BluetoothRacketsList({super.key});

  void startRescanTimer(BuildContext context, SensorsBloc sensorsBloc) {
    Timer.periodic(Duration(seconds: 10), (_) {
      //TODO COmprobar si no esta cargando  para  evitar que se  desactualice la lista mientras se esta conectando.
      sensorsBloc.add(OnReScanBluetoothSensors());
    });
  }

  @override
  Widget build(BuildContext context) {
    final sensorsBloc = BlocProvider.of<SensorsBloc>(context);
    sensorsBloc.add(OnStartScanBluetoothSensors());

    SchedulerBinding.instance.addPostFrameCallback((_) {
      startRescanTimer(context, sensorsBloc);
    });

    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: BlocListener<SensorsBloc, SensorsState>(
        listener: (context, state) {
          if (state.selectedRacketEntity != null && state.uiState.next != null) {
            Navigator.pop(context);
            sensorsBloc.add( OnStopScanBluetoothSensors() );
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
                    height: MediaQuery.of(context).size.height/4,
                    child: ListView.builder(
                      itemCount: state.sensors.length,
                      itemBuilder: (BuildContext context, int index1) {
                        final entity = state.sensors[index1];
                        return RacketEntityListItem(entity: entity);
                      },
                    ),
                  ),
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
