import 'package:aerox_stage_1/features/feature_bluetooth/blocs/sensors/sensors_bloc.dart';
import 'package:aerox_stage_1/features/feature_home/ui/home_page_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.sports_tennis_outlined),
                            SizedBox(width: 10),
                            Text(state.sensors[index1].name),
                          ],
                        ),
                        SizedBox(height: 5),
                        SizedBox(
                          height: 100, 
                          child: ListView.builder(
                            itemCount: state.sensors[index1].sensors.length,
                            itemBuilder: (BuildContext context, int index2) {
                              return Text('Sensor: ${state.sensors[index1].sensors[index2].id}');
                            },
                          ),
                        ),
                        Divider(),
                      ],
                    );
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
    );
  }
}
