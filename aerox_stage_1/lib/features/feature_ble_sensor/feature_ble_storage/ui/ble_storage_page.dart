import 'package:aerox_stage_1/features/feature_ble_sensor/feature_ble_storage/blocs/ble_storage/ble_storage_bloc.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_ble_storage/ui/blob_storage_list.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_blob_database/ui/export_to_csv_button.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BleStoragePage extends StatelessWidget {
  const BleStoragePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bleStoragePageBloc = BlocProvider.of<BleStorageBloc>(context);
    bleStoragePageBloc.add(OnGetSelectedRacketBleStoragePage());


    return Scaffold(
      appBar: AppBar(
        title: Text('BLE Storage'),
      ),
      body: BlocListener<BleStorageBloc, BleStorageState>(
        listener: (context, state) {
          if(state.selectedRacketEntity  != null  ){
            bleStoragePageBloc.add(OnReadStorageDataBleStoragePage(
              sensor: bleStoragePageBloc.state.selectedRacketEntity!.sensors[0])
            );
            bleStoragePageBloc.add(OnFilterBlobsByDate(DateTime.utc(2000, 1, 1)));
          }
        },
        child: Container(
          height: MediaQuery.of(context).size.height*0.9,
          child: Column(
            children: [

              BlobStorageList()
              ],
          ),
        ),
      ),
    );
  }
}
