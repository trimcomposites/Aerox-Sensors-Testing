import 'package:aerox_stage_1/features/feature_bluetooth/blocs/selected_entity_page/selected_entity_page_bloc.dart';
import 'package:aerox_stage_1/features/feature_home/ui/home_page_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedRacketName extends StatelessWidget {
  const SelectedRacketName({
    super.key, this.showStorage = false ,
  });
  final bool showStorage;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectedEntityPageBloc, SelectedEntityPageState>(
      builder: (context, state) {
        return Container(
          height: 300,
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state.selectedRacketEntity != null)
                Text('Pala seleccionada:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
              Row(
                children: [
                  Text(
                    state.selectedRacketEntity?.name ??
                        'No hay raqueta seleccionada',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  Icon( Icons.storage, color: Colors.blue.shade400, )
                ],
              ),
              const SizedBox(height: 12),
              if (state.selectedRacketEntity != null)
                Expanded(
                  child: ListView.builder(
                    itemCount: state.selectedRacketEntity!.sensors.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final sensor = state.selectedRacketEntity!.sensors[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.sensors, size: 20, color: Colors.blue),
                            const SizedBox(width: 8),
                            Text(sensor.id, style: TextStyle( fontSize: showStorage ? 10 : null ),),
                            const Spacer(),
                            showStorage
                            ? Text('15')
                            : Container()
                          ],
                        ),
                      );
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
