import 'package:aerox_stage_1/features/feature_ble_sensor/feature_rtsos_hs/blocs/rtsos_lobby/rtsos_lobby_bloc.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HitTypeSelectDropDown extends StatelessWidget {
  const HitTypeSelectDropDown({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    final rtsosLobbyBloc = BlocProvider.of<RtsosLobbyBloc>(context);
    return BlocBuilder<RtsosLobbyBloc, RtsosLobbyState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade400),
          ),
          width: MediaQuery.of(context).size.width / 1.1,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: state.selectedHitType,
              hint: const Text('Selecciona un tipo de golpe'),
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: state.hitTypes.map((hitType) {
                final description =
                    RTSOSCommonValues.hitTypeDescriptions[hitType];
                return DropdownMenuItem(
                  value: hitType,
                  child: Row(
                    children: [
                      Icon(Icons.sports_tennis,
                          size: 18, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          description ?? hitType,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  rtsosLobbyBloc.add(OnHitTypeValueChanged(value));
                }
              },
            ),
          ),
        );
      },
    );
  }
}
