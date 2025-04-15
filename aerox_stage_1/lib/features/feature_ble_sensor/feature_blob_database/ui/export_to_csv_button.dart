import 'package:aerox_stage_1/features/feature_ble_sensor/feature_ble_storage/blocs/ble_storage/ble_storage_bloc.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_blob_database/blocs/blob_database/blob_database_bloc.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExportToCSVButton extends StatelessWidget {
  const ExportToCSVButton({
    super.key,

  });



  @override
  Widget build(BuildContext context) {
      final blobDatabaseBloc = BlocProvider.of<BlobDatabaseBloc>(context);
    return TextButton.icon(
      onPressed: (){
        for(var blob  in blobDatabaseBloc.state.blobs ){
          //bleStoragePageBloc.add(OnParseBlobBleStorage(blob: blob ));
        }
    
      }, 
      label: Text( 'Exportar a CSV' ),
      icon: Icon( Icons.import_export, color: Colors.green, ),
    );
  }
}
