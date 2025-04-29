import 'dart:async'; // 👈 importante

import 'package:aerox_stage_1/features/feature_ble_sensor/feature_rtsos_hs/blocs/rtsos_lobby/rtsos_lobby_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetNumBobsEventTimer extends StatefulWidget {
  const GetNumBobsEventTimer({super.key});

  @override
  State<GetNumBobsEventTimer> createState() => _GetNumBobsEventTimerState();
}

class _GetNumBobsEventTimerState extends State<GetNumBobsEventTimer> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final rtsosLobbyBloc = BlocProvider.of<RtsosLobbyBloc>(context, listen: false);

   _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      final isRecording = rtsosLobbyBloc.state.isRecording;
      if (!isRecording) {
        rtsosLobbyBloc.add(OnGetSensorsNumBlobs());
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Muy importante liberar el timer al destruirse
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(); // invisible widget
  }
}
