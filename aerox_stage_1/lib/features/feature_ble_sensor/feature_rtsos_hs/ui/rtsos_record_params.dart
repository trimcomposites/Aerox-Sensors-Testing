import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';

class RTSOSRecordParams extends StatelessWidget {
  const RTSOSRecordParams({
    super.key,
    required this.sampleRate,
  });

  final double sampleRate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Parámetros Seleccionados:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        const SizedBox(height: 8),
        Text(
          sampleRate==1
          ? "• SAMPLE RATE: 1KHZ" 
          : "• SAMPLE RATE: 104hz",
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
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
  }
}
