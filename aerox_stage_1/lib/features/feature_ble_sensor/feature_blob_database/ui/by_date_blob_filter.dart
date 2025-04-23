import 'package:aerox_stage_1/features/feature_ble_sensor/feature_blob_database/blocs/blob_database/blob_database_bloc.dart';
import 'package:aerox_stage_1/features/feature_home/ui/home_page_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ByDateBlobFilter extends StatelessWidget {
  const ByDateBlobFilter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
        final blobDatabaseBloc = BlocProvider.of<BlobDatabaseBloc>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now(),
          );
          if (picked != null) {
            blobDatabaseBloc.add(OnFilterDatabaseBlobsByExactDate(picked));
          }
        },
        child: const Text('Seleccionar fecha límite'),
      ),
    );
  }
}
