import 'package:aerox_stage_1/features/feature_bluetooth/blocs/sensors/sensors_bloc.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/ui/bluetooth_rackets_list.dart';
import 'package:aerox_stage_1/features/feature_home/ui/home_page_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BluetoothConnectButton extends StatelessWidget {
  const BluetoothConnectButton({
    super.key, required this.position,
  });
  final double position;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: position,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha( 60 ), 
              spreadRadius: 2, 
              blurRadius: 10,    
              offset: Offset(4, 4), 
            ),
          ]
        ),
        width: 250,
        height: 100,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // final userBloc = BlocProvider.of<UserBloc>(context);
            // userBloc.add( OnEmailSignOutUser() );
            // userBloc.add( OnGoogleSignOutUser() );

            showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)), // Bordes redondeados arriba
              ),
              builder: (BuildContext context) {
                return BluetoothRacketsList();
              },
            ).whenComplete((){
              final sensorsBloc = BlocProvider.of<SensorsBloc>(context);
              sensorsBloc.add( OnStopScanBluetoothSensors() );
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.only( left: 25 ),
                child: Text( 
                  'CONECTA', 
                  style: TextStyle( 
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ), 
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 40,
                  width: 40,
                  color: appYellowColor,
                  child: Icon( Icons.bluetooth )
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
