import 'package:aerox_stage_1/domain/use_cases/ble_sensor/start_offline_rtsos_usecase.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';

class RTSOSRecordParamsWidget extends StatelessWidget {
  const RTSOSRecordParamsWidget({
    super.key,
    required this.sampleRate,
  });

  final SampleRate sampleRate;

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
          sampleRate== SampleRate.khz1
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
