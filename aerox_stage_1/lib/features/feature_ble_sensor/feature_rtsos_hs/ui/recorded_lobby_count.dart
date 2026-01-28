import 'package:aerox_stage_1/features/feature_ble_sensor/feature_rtsos_hs/blocs/rtsos_lobby/rtsos_lobby_bloc.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecordedLobbyCount extends StatelessWidget {
  const RecordedLobbyCount({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RtsosLobbyBloc, RtsosLobbyState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.blue.shade200, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Contenido de texto + icono
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.cloud_upload_rounded, color: Colors.blue.shade600, size: 28),
                  const SizedBox(height: 4),
                  Text(
                    '${state.recordedBlobCounter} blobs registrados',
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'en esta sesión',
                    style: TextStyle(
                      color: Colors.blueGrey.shade700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 16),

              // Botón de reset
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.refresh, size: 20, color: Colors.blue),
                  tooltip: 'Reiniciar contador',
                  onPressed: () {
                    context.read<RtsosLobbyBloc>().add(OnResetBlobRecordedCounter());
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
