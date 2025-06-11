import 'dart:io';

import 'package:aerox_stage_1/domain/models/parsed_blob.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_blob_database/blocs/blob_database/blob_database_bloc.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_blob_database/ui/blob_database_list_tile.dart';
import 'package:aerox_stage_1/features/feature_home/ui/home_page_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class BlobDataBaseList extends StatelessWidget {
  const BlobDataBaseList({super.key});

  @override
  Widget build(BuildContext context) {
    final blobDataBaseBloc = BlocProvider.of<BlobDatabaseBloc>(context);
    return Expanded(
      child: BlocBuilder<BlobDatabaseBloc, BlobDatabaseState>(
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.filteredBlobs.length,
            itemBuilder: (BuildContext context, int index) {
              final blob = state.filteredBlobs[index];
              final timestamp = blob.content.first['timestamp'] ?? 'Sin timestamp';
              final path = blob.path ?? '';
              final hasPath = path.isNotEmpty;

              return BlobDatabaseListTile(hasPath: hasPath, timestamp: timestamp, blob: blob,);
            },
          );
        },
      ),
    );
  }
}
