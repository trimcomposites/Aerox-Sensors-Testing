import 'package:aerox_stage_1/features/feature_home/ui/home_page_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BluetoothConnectButton extends StatelessWidget {
  const BluetoothConnectButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 50,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha( 60 ), 
              spreadRadius: 2, 
              blurRadius: 10,    
              offset: Offset(4, 4), 
            ),
          ]
        ),
        width: 150,
        height: 40,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            final userBloc = BlocProvider.of<UserBloc>(context);
            userBloc.add( OnEmailSignOutUser() );
            userBloc.add( OnGoogleSignOutUser() );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only( left: 25 ),
                child: Text( 
                  'CONECTA', 
                  style: TextStyle( 
                    fontSize: 12
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


