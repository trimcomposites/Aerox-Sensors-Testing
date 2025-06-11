import 'dart:io';
import 'package:aerox_stage_1/domain/models/parsed_blob.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_blob_database/blocs/blob_database/blob_database_bloc.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_blob_database/ui/open_blob_action_button.dart';
import 'package:aerox_stage_1/features/feature_home/ui/home_page_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
class BlobDatabaseListTile extends StatelessWidget {
  const BlobDatabaseListTile({
    super.key,
    required this.hasPath,
    required this.timestamp,
    required this.blob,
  });

  final bool hasPath;
  final dynamic timestamp;
  final ParsedBlob blob;
  
  @override
  Widget build(BuildContext context) {
    final state = context.watch<BlobDatabaseBloc>().state;
    final isSelected = state.selectedBlobs.contains(blob);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(
          Icons.insert_drive_file,
          color: hasPath ? Colors.green : Colors.grey,
        ),
        title: Text('BLOB ${blob.position} ${blob.createdAt}'),
        subtitle: Text('Fecha: $timestamp'),
        trailing: hasPath
            ? Checkbox(
                value: isSelected,
                onChanged: (value) {
                  if (value == true) {
                    context.read<BlobDatabaseBloc>().add(OnAddBlobToSelectedList(blob: blob));
                  } else {
                    context.read<BlobDatabaseBloc>().add(OnRemoveBlobFromSelectedList(blob: blob));
                  }
                },
              )
            : null,
      ),
    );
  }
}
