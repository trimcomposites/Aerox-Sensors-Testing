import 'package:aerox_stage_1/features/feature_ble_sensor/feature_blob_database/blocs/blob_database/blob_database_bloc.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_blob_database/ui/blob_data_base_list.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_blob_database/ui/export_to_csv_button.dart';
import 'package:aerox_stage_1/features/feature_home/ui/home_page_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlobDatabasePage extends StatelessWidget {
  const BlobDatabasePage({super.key});

  @override
  Widget build(BuildContext context) {
    final blobDatabaseBloc = BlocProvider.of<BlobDatabaseBloc>(context);
    blobDatabaseBloc.add( OnReadBlobDatabase() );
    return Scaffold(
      appBar: AppBar(
        title: Text( 'Blob Database' ),
      ),
      body: Column(
        children: [

          ExportToCSVButton(),
          BlobDataBaseList(),
        ],
      ),
    );
  }
}
