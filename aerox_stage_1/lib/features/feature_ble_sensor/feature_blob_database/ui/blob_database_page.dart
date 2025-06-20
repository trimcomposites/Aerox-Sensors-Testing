import 'package:aerox_stage_1/common/ui/error_dialog.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_ble_storage/ui/blob_storage_list.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_blob_database/blocs/blob_database/blob_database_bloc.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_blob_database/ui/blob_data_base_list.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_blob_database/ui/by_date_blob_filter.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_blob_database/ui/by_exact_date_blob_filter.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_blob_database/ui/export_to_csv_button.dart';
import 'package:aerox_stage_1/features/feature_home/ui/home_page_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlobDatabasePage extends StatelessWidget {
  const BlobDatabasePage({super.key});



  
  @override
  Widget build(BuildContext context) {
    final blobDatabaseBloc = BlocProvider.of<BlobDatabaseBloc>(context);
    blobDatabaseBloc.add(OnReadBlobDatabase());
    blobDatabaseBloc.add(OnGetErrorLogs());
    blobDatabaseBloc.add(OnResetBlobSelectedList());
    return Scaffold(
      appBar: AppBar(
        title: Text('Blob Database'),
        actions: [
          TextButton(
            onPressed: () {
              if(context.read<BlobDatabaseBloc>().state.selectedBlobs.length >= 0 ){
                ErrorDialog.showCustomDialog(
                  context: context,
                  title: 'Subir archivos',
                  message: '¿Estás seguro de que deseas subir estos blobs a la nube? ${blobDatabaseBloc.state.filteredBlobs.length} blob(s)',
                  onOk: () {
                    context.read<BlobDatabaseBloc>().add(
                      OnUploadErrorLogs()
                    );
                    context.read<BlobDatabaseBloc>().add(
                      OnUploadBlobsToStorage(
                        blobs: context.read<BlobDatabaseBloc>().state.selectedBlobs,
                      ),
                    );
                  },
                );
              }else{
                ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text('Debes Seleccionar al menos UN Blob para Subir.')) );
              }
          }, child: Text('Subir Archivos')),
          TextButton.icon(
            icon: Icon(Icons.delete),
            onPressed: () {
              if(context.read<BlobDatabaseBloc>().state.selectedBlobs.length >= 0 ){
                ErrorDialog.showCustomDialog(
                  context: context,
                  title: 'Subir archivos',
                  message: '¿Estás seguro de que deseas borrar la base de datos? No podrás recuperar los archivos una vez borrados. Los cambios serán visibles una vez reiniciada la Aplicación.',
                  onOk: () {
                    context.read<BlobDatabaseBloc>().add(
                      OnEraseBlobDatabase(),
                    );
                  },
                );
              }else{
                ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text('Debes Seleccionar al menos UN Blob para Subir.')) );
              }
          }, label: Text('Eliminar BD')),
        ],
      ),
      body: Column(
        children: [
          SelectDatabaseBlobActions(),
          ByExactDateBlobFilter(),
          ByDateBlobFilter(),
          BlocBuilder<BlobDatabaseBloc, BlobDatabaseState>(
            builder: (context, state) {
              return Text('( ${state.selectedBlobs.length} ) Blobs seleccionados.');
            },
          ),
          ExportToCSVButton(),

          BlobDataBaseList(),
        ],
      ),
    );
  }
}

class SelectDatabaseBlobActions extends StatelessWidget {
  const SelectDatabaseBlobActions({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    final blobDatabaseBloc = BlocProvider.of<BlobDatabaseBloc>(context);

    return Row(
      children: [
        TextButton(onPressed: () {
          blobDatabaseBloc.add(OnAddAllBlobsToSelectedList());
        }, child: Text('Seleccionar Todo')),
        TextButton(onPressed: () {
          blobDatabaseBloc.add(OnResetBlobSelectedList());
        }, child: Text('Anular Selecciones'))
      ],
    );
  }
}
