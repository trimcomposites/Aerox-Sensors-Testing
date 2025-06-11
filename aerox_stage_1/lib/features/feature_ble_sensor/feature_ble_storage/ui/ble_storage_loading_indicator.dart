import 'package:aerox_stage_1/features/feature_ble_sensor/feature_ble_storage/blocs/ble_storage/ble_storage_bloc.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BleStorageLoadingIndicator extends StatelessWidget {
  const BleStorageLoadingIndicator({
    super.key,
    this.showBackGround = true,
  });
  final bool showBackGround;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height:100,
      color: showBackGround ? Colors.black.withAlpha(128) : Colors.transparent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            BlocBuilder<BleStorageBloc, BleStorageState>(
              builder: (context, state) {
                return Text('Blobs leídos ${state.blobsRead}/${state.totalBlobs}');
              },
            ),
          ],
        ),
      ),
);

  }
}
