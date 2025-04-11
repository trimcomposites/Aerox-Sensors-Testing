import 'package:aerox_stage_1/features/feature_ble_sensor/feature_rtsos_hs/blocs/rtsos_lobby/rtsos_lobby_bloc.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DurationSelectorWithInput extends StatelessWidget {
  const DurationSelectorWithInput({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RtsosLobbyBloc>();

    return BlocBuilder<RtsosLobbyBloc, RtsosLobbyState>(
      builder: (context, state) {
        final controller = TextEditingController(text: state.durationSeconds.toString());

        void updateValue(int newValue) {
          if (newValue >= 1) {
            bloc.add(OnRtsosDurationChanged(newValue));
          }
        }

        return Container(
          width: MediaQuery.of(context).size.width/2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Duración (segundos):',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => updateValue(state.durationSeconds - 1),
                    ),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        onSubmitted: (value) {
                          final intValue = int.tryParse(value);
                          if (intValue != null && intValue >= 1) {
                            updateValue(intValue);
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => updateValue(state.durationSeconds + 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
