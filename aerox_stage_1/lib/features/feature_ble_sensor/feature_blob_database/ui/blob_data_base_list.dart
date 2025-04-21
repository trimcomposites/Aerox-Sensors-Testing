import 'dart:io';

import 'package:aerox_stage_1/features/feature_ble_sensor/feature_blob_database/blocs/blob_database/blob_database_bloc.dart';
import 'package:aerox_stage_1/features/feature_home/ui/home_page_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';

class BlobDataBaseList extends StatelessWidget {
  const BlobDataBaseList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<BlobDatabaseBloc, BlobDatabaseState>(
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.blobs.length,
            itemBuilder: (BuildContext context, int index) {
              final blob = state.blobs[index];
              final timestamp = blob.content.first['timestamp'] ?? 'Sin timestamp';
              final path = blob.path ?? '';
              final hasPath = path.isNotEmpty;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: Icon(
                    Icons.insert_drive_file,
                    color: hasPath ? Colors.green : Colors.grey,
                  ),
                  title: Text('BLOB $index'),
                  subtitle: Text('Fecha: $timestamp'),
                  trailing: hasPath
                      ? IconButton(
                          icon: const Icon(Icons.open_in_new, color: Colors.blueAccent),
                          onPressed: () async {
                            final exists = await File(path).exists();
                            print('¿El archivo existe?: $exists');

                            await OpenFilex.open(path);
                          },
                        )
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
