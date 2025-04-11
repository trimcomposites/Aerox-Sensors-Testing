import 'package:aerox_stage_1/features/feature_ble_sensor/feature_rtsos_hs/blocs/rtsos_lobby/rtsos_lobby_bloc.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_rtsos_hs/ui/hit_type_select_drop_down.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_rtsos_hs/ui/rtsos_record_params.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/ui/ble_record_with_button.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RTSOSRecordingLobby extends StatelessWidget {
  const RTSOSRecordingLobby({super.key, required this.sampleRate});

  final double sampleRate;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Iniciar Grabación SIN Cámaras',
          style: TextStyle(fontSize: 25),
        ),
        leading: Container(),
      ),
      body: Center(
        child: BlocBuilder<RtsosLobbyBloc, RtsosLobbyState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              RTSOSRecordParams(sampleRate: sampleRate),
                 
              const SizedBox(height: 16),
              
                sampleRate!= 1
                ? HitTypeSelectDropDown()
                : Container(),
                BleRecordWithButton(
                  text: 'INICIAR GRABACIÓN',
                  color: Colors.red,
                  onPressed: () {},
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
