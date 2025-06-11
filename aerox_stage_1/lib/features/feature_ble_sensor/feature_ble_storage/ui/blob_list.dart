import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_ble_storage/blocs/ble_storage/ble_storage_bloc.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_ble_storage/ui/ble_storage_loading_indicator.dart';
import 'package:aerox_stage_1/features/feature_home/ui/home_page_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlobList extends StatelessWidget {
  const BlobList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.9,
      height: MediaQuery.of(context).size.height/2,
      child: BlocBuilder<BleStorageBloc, BleStorageState>(
        builder: (context, state) {
      final blobs = state.blobsBySensor.values.expand((list) => list).toList();
      
            
          return state.uiState.status == UIStatus.loading
          ? BleStorageLoadingIndicator( showBackGround: false,  )
          : ListView.builder(
            itemCount: blobs.length,
            itemBuilder: (BuildContext context, int index) {
              final blob = blobs[index];
              return Row(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        "blob ${blob.createdAt}",
                        maxLines: 10,
                      ),
                    ),
                  ), 
                ],
              );
            },
          );
        },
      ),
    );
  }
}
