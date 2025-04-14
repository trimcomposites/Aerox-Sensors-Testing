import 'package:aerox_stage_1/features/feature_bluetooth/blocs/ble_storage/ble_storage_bloc.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/ui/blob_storage_list.dart';
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
              TextButton.icon(
                onPressed: (){
                  for(var blob  in bleStoragePageBloc.state.blobs ){
                    bleStoragePageBloc.add(OnParseBlobBleStorage(blob: blob ));
                  }

                }, 
                label: Text( 'Exportar a CSV' ),
                icon: Icon( Icons.import_export, color: Colors.green, ),
              ),
              BlobStorageList()
              ],
          ),
        ),
      ),
    );
  }
}
