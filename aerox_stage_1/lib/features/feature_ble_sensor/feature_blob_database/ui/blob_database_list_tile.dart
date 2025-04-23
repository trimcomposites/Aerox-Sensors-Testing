import 'dart:io';
import 'package:aerox_stage_1/domain/models/parsed_blob.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_blob_database/blocs/blob_database/blob_database_bloc.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_blob_database/ui/open_blob_action_button.dart';
import 'package:aerox_stage_1/features/feature_home/ui/home_page_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
class BlobDatabaseListTile extends StatefulWidget {
  const BlobDatabaseListTile({
    super.key,
    required this.hasPath,
    required this.timestamp,
    required this.blob,
    required this.index
  });

  final bool hasPath;
  final dynamic timestamp;
  final ParsedBlob blob;
  final int index;

  @override
  State<BlobDatabaseListTile> createState() => _BlobDatabaseListTileState();
}

class _BlobDatabaseListTileState extends State<BlobDatabaseListTile> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    final blobDatabaseBlob = BlocProvider.of<BlobDatabaseBloc>(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(
          Icons.insert_drive_file,
          color: widget.hasPath ? Colors.green : Colors.grey,
        ),
        title: Text('BLOB ${widget.index}'),
        subtitle: Text('Fecha: ${widget.timestamp}'),
        trailing: widget.hasPath
            ? Checkbox(
                value: selected,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selected = value;
                      if(selected==true){
                      blobDatabaseBlob.add( OnAddBlobToSelectedList(blob: widget.blob) );
                    }else{
                       blobDatabaseBlob.add( OnRemoveBlobFromSelectedList(blob: widget.blob) );
                    }
                    });
                    
                  }
                },
              )
            : null,
      ),
    );
  }
}
