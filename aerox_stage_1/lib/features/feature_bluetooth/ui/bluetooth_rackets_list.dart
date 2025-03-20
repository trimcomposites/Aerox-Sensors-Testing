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
    sensorsBloc.add( OnStartScanBluetoothSensors() );
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.white, // Fondo blanco
      child: BlocBuilder<SensorsBloc, SensorsState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Dispositivos Encontrados:"),
              SizedBox(height: 10),

              Container(
                height: 200,
                child: ListView.builder(
                  itemCount: state.sensors.length,
                  itemBuilder: (BuildContext context, int index) {
                    return 
                      Row(
                        children: [
                          Icon(Icons.sports_tennis_outlined),
                          Text( state.sensors[index].name ),
                        ],
                      )
                    ;
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
