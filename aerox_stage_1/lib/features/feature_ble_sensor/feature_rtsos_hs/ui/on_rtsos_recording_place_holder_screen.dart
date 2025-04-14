import 'dart:async';
import 'package:flutter/material.dart';

class OnRTSOSRecordingPlaceHolderScreen extends StatefulWidget {
  final int durationSeconds;

  const OnRTSOSRecordingPlaceHolderScreen({
    super.key,
    required this.durationSeconds,
  });

  @override
  State<OnRTSOSRecordingPlaceHolderScreen> createState() =>
      _OnRTSOSRecordingPlaceHolderScreenState();
}

class _OnRTSOSRecordingPlaceHolderScreenState extends State<OnRTSOSRecordingPlaceHolderScreen> {
  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.durationSeconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 1) {
        timer.cancel();
        Navigator.of(context).pop();
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // 🚫 Bloquea volver atrás
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Grabando...',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                '$_remainingSeconds',
                style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
