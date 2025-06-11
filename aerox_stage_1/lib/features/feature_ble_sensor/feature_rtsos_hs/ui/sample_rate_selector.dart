import 'package:aerox_stage_1/domain/use_cases/ble_sensor/start_offline_rtsos_usecase.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_rtsos_hs/blocs/rtsos_lobby/rtsos_lobby_bloc.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SampleRateSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final rtsosLobbyBloc = BlocProvider.of<RtsosLobbyBloc>(context);

    return BlocBuilder<RtsosLobbyBloc, RtsosLobbyState>(
      builder: (context, state) {
        final selectedRate = state.sampleRate;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ChoiceChip(
              label: const Text('104 Hz'),
              labelStyle: TextStyle(
                color: selectedRate == SampleRate.hz104
                    ? Colors.white
                    : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
              selected: selectedRate == SampleRate.hz104,
              selectedColor: Colors.green,
              backgroundColor: Colors.grey.shade200,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              onSelected: (_) {
                rtsosLobbyBloc
                    .add(OnChangeSampleRate(sampleRate: SampleRate.hz104));
              },
            ),
            const SizedBox(width: 16),
            ChoiceChip(
              label: const Text('1 kHz'),
              labelStyle: TextStyle(
                color: selectedRate == SampleRate.khz1
                    ? Colors.white
                    : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
              selected: selectedRate == SampleRate.khz1,
              selectedColor: Colors.blue,
              backgroundColor: Colors.grey.shade200,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              onSelected: (_) {
                rtsosLobbyBloc
                    .add(OnChangeSampleRate(sampleRate: SampleRate.khz1));
              },
            ),
          ],
        );
      },
    );
  }
}
