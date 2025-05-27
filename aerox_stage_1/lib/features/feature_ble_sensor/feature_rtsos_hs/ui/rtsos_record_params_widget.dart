import 'package:aerox_stage_1/domain/use_cases/ble_sensor/start_offline_rtsos_usecase.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_rtsos_hs/blocs/rtsos_lobby/rtsos_lobby_bloc.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RTSOSRecordParamsWidget extends StatelessWidget {
  const RTSOSRecordParamsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final rtsosLobbyBloc = BlocProvider.of<RtsosLobbyBloc>(context);

    return BlocBuilder<RtsosLobbyBloc, RtsosLobbyState>(
      builder: (context, state) {
        final SampleRate sampleRate = rtsosLobbyBloc.state.sampleRate;

        final String sampleRateLabel = sampleRate == SampleRate.khz1
            ? "1KHZ"
            : "104HZ";

        final Color backgroundColor = sampleRate == SampleRate.khz1
            ? Colors.blue.shade100
            : Colors.green.shade100;

        final Color textColor = sampleRate == SampleRate.khz1
            ? Colors.blue.shade800
            : Colors.green.shade800;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Parámetros Seleccionados:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "• SAMPLE RATE: $sampleRateLabel",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              '• ACC: 16G, 2000DPS',
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
            const Text(
              '• ACC_SCALE, GYRO_SCALE',
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ],
        );
      },
    );
  }
}
