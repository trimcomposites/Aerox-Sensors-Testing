import 'package:aerox_stage_1/features/feature_ble_sensor/feature_ble_storage/blocs/ble_storage/ble_storage_bloc.dart';
import 'package:aerox_stage_1/features/feature_home/ui/home_page_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ByExactDateBlobFilter extends StatelessWidget {
  const ByExactDateBlobFilter({
    super.key,

  });


  @override
  Widget build(BuildContext context) {
    final bleStorageBloc = BlocProvider.of<BleStorageBloc>(context);
    return BlocBuilder<BleStorageBloc, BleStorageState>(
      builder: (context, state) {
        final allDates = state.blobs
            .where((b) => b.createdAt != null)
            .map((b) => DateTime(b.createdAt!.year, b.createdAt!.month, b.createdAt!.day))
            .toSet()
            .toList()
          ..sort();
          
        return Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: allDates.map((date) {
            final dateStr = DateFormat('yyyy-MM-dd').format(date);
            return ElevatedButton(
              onPressed: () {
                bleStorageBloc.add(OnFilterBlobsByExactDay(date));
              },
              child: Text(dateStr),
            );
          }).toList(),
        );
      },
    );
  }
}
