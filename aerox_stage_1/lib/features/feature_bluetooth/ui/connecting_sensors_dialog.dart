import 'package:aerox_stage_1/features/feature_bluetooth/blocs/sensors/sensors_bloc.dart';
import 'package:aerox_stage_1/features/feature_home/ui/home_page_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConnectingSensorsDialog extends StatelessWidget {
  const ConnectingSensorsDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Mensaje Importante'),
      content: Text('Este es un diálogo modal que no se puede cerrar.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: BlocBuilder<SensorsBloc, SensorsState>(
            builder: (context, state) {
              return Column(
                children: [
                   
                  Text('Aceptar'),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
