import 'package:aerox_stage_1/common/ui/error_dialog.dart';
import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/domain/use_cases/ble_sensor/start_offline_rtsos_usecase.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_rtsos_hs/blocs/rtsos_lobby/rtsos_lobby_bloc.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_rtsos_hs/ui/duration_selector_with_input.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_rtsos_hs/ui/hit_type_select_drop_down.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_rtsos_hs/ui/on_rtsos_recording_place_holder_screen.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_rtsos_hs/ui/rtsos_record_params_widget.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/ui/ble_record_with_button.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/ui/selected_racket_name.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RTSOSRecordingLobby extends StatelessWidget {
  const RTSOSRecordingLobby({super.key, required this.sampleRate});

  final SampleRate sampleRate;

  @override
  Widget build(BuildContext context) {
    final rtsosLobbyBloc = BlocProvider.of<RtsosLobbyBloc>(context);
    rtsosLobbyBloc.add(OnGetSelectedRacketSensorEntityLobby());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Iniciar Grabación SIN Cámaras',
          style: TextStyle(fontSize: 25),
        ),
        leading: Container(),
      ),
      body: Center(
        child: BlocListener<RtsosLobbyBloc, RtsosLobbyState>(
          listener: (context, state) {
            if (state.sensorEntity == null &&
                state.uiState.status == UIStatus.error) {
              ErrorDialog.showErrorDialog(context, state.uiState.errorMessage);
            }
          },
          child: BlocBuilder<RtsosLobbyBloc, RtsosLobbyState>(
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SelectedRacketName( showStorage: true, ),
                  RTSOSRecordParamsWidget(sampleRate: sampleRate),
                  const SizedBox(height: 16),
                  sampleRate != SampleRate.hz104 ? HitTypeSelectDropDown() : Container(),
                  DurationSelectorWithInput(),
                  BleRecordWithButton(
                    text: 'INICIAR GRABACIÓN',
                    color: sampleRate != SampleRate.khz1 ||
                            sampleRate == SampleRate.khz1 && state.selectedHitType != null
                        ? Colors.red
                        : Colors.grey,
                    onPressed: () {
                      if (sampleRate == SampleRate.khz1 ||
                          sampleRate != SampleRate.khz1 && state.selectedHitType != null) {
                        rtsosLobbyBloc.add(OnStartHSBlobOnLobby(
                            duration: state.durationSeconds,
                            sampleRate: sampleRate));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    OnRTSOSRecordingPlaceHolderScreen(
                                        durationSeconds:
                                            state.durationSeconds)));
                      }
                    },
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
