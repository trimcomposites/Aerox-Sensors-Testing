import 'package:aerox_stage_1/common/ui/error_dialog.dart';
import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/domain/use_cases/ble_sensor/start_offline_rtsos_usecase.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_rtsos_hs/blocs/rtsos_lobby/rtsos_lobby_bloc.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_rtsos_hs/ui/duration_selector_with_input.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_rtsos_hs/ui/get_num_bobs_event_timer.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_rtsos_hs/ui/hit_type_select_drop_down.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_rtsos_hs/ui/on_rtsos_recording_place_holder_screen.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_rtsos_hs/ui/rtsos_record_params_widget.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_rtsos_hs/ui/sample_rate_selector.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/ui/ble_record_with_button.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/ui/selected_racket_name.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RTSOSRecordingLobby extends StatelessWidget {
  const RTSOSRecordingLobby({super.key});

  @override
  Widget build(BuildContext context) {
    final rtsosLobbyBloc = BlocProvider.of<RtsosLobbyBloc>(context);
    rtsosLobbyBloc.add(OnGetSelectedRacketSensorEntityLobby());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Grabación',
          style: TextStyle(fontSize: 25),
        ),
        leading: Container(),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: BlocListener<RtsosLobbyBloc, RtsosLobbyState>(
            listener: (context, state) {
              if (state.sensorEntity == null &&
                  state.uiState.status == UIStatus.error) {
                ErrorDialog.showErrorDialog(context, state.uiState.errorMessage);
              }
            },
            child: BlocBuilder<RtsosLobbyBloc, RtsosLobbyState>(
              builder: (context, state) {
                final sampleRate = rtsosLobbyBloc.state.sampleRate;
                final bool canStartRecording = 
                    !state.isRecording &&
                    state.uiState.status != UIStatus.loading;
                    // (
                    //   (sampleRate == SampleRate.khz1) ||
                    //   (sampleRate == SampleRate.hz104 && state.selectedHitType != null)
                    // );
        
        
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GetNumBobsEventTimer(),
                      SelectedRacketName(
                        showStorage: true,
                      ),
                      RTSOSRecordParamsWidget(),
                      BlocBuilder<RtsosLobbyBloc, RtsosLobbyState>(
                        builder: (context, state) {
                          return Container(
                            child: Text('${state.recordedBlobCounter} Blobs Registrados en esta sesión.'),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      SampleRateSelector(),
                      // sampleRate != SampleRate.khz1
                      //     ? HitTypeSelectDropDown()
                      //     : Container(),
                      DurationSelectorWithInput(),
                      BleRecordWithButton(
                        text: 'INICIAR GRABACIÓN',
                        color: canStartRecording ? Colors.red : Colors.grey,
                        onPressed: canStartRecording
                            ? ()async {
                                rtsosLobbyBloc.add(OnStartHSRecording());
                                rtsosLobbyBloc.add(OnStartHSBlobOnLobby(
                                  duration: state.durationSeconds,
                                  sampleRate: sampleRate,
                                ));
                                print('Comenzada grabacion a ${sampleRate}');
                                await Future.delayed(Duration(seconds: state.durationSeconds + 3));
        
                                rtsosLobbyBloc.add(OnStopHSRecording());
                                rtsosLobbyBloc.add(OnAddBlobRecordedCounter());
                              }
                            : null, 
                      ),
                      // sampleRate == SampleRate.hz104
                      //     ? BleRecordWithButton(
                      //         text: 'TIEMPO MAX.',
                      //         color:
                      //             canStartRecording ? Colors.blue : Colors.grey,
                      //         onPressed: canStartRecording
                      //           ? ()async {
                      //           rtsosLobbyBloc.add(OnStartHSRecording());
                      //           rtsosLobbyBloc.add(OnStartHSBlobOnLobby(
                      //             duration: 254,
                      //             sampleRate: sampleRate,
                      //           ));
                      //           await Future.delayed(Duration(seconds: 254 + 3));
        
                      //           rtsosLobbyBloc.add(OnStopHSRecording());
                      //           rtsosLobbyBloc.add(OnAddBlobRecordedCounter());
                      //         }
                      //             : null,
                      //       )
                      //     : Container(),
                    ]);
              },
            ),
          ),
        ),
      ),
    );
  }
}
