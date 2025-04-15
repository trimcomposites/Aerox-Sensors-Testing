import 'package:aerox_stage_1/features/feature_bluetooth/blocs/ble_storage/ble_storage_bloc.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/blocs/selected_entity_page/selected_entity_page_bloc.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/ui/by_exact_date_blob_filter.dart';
import 'package:aerox_stage_1/features/feature_home/ui/home_page_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class BlobStorageList extends StatelessWidget {
  const BlobStorageList({super.key});

  @override
  Widget build(BuildContext context) {
    final bleStorageBloc = BlocProvider.of<BleStorageBloc>(context);

    return Expanded(
      child: Column(
        children: [
          ByExactDateBlobFilter(),
          ByDateBlobFilter(),
          const SizedBox(height: 8),
          Expanded(
            child: BlocBuilder<BleStorageBloc, BleStorageState>(
              builder: (context, state) {
                final filteredBlobs = state.filteredBlobs;
      
                return ListView.builder(
                  itemCount: filteredBlobs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final blob = filteredBlobs[index];
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
                        IconButton(
                          onPressed: () {
                            //bleStorageBloc.add(OnParseBlob(blob: blob));
                          },
                          icon: const Icon(Icons.arrow_circle_up),
                        )
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ByDateBlobFilter extends StatelessWidget {
  const ByDateBlobFilter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
        final bleStorageBloc = BlocProvider.of<BleStorageBloc>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now(),
          );
          if (picked != null) {
            bleStorageBloc.add(OnFilterBlobsByDate(picked));
          }
        },
        child: const Text('Seleccionar fecha límite'),
      ),
    );
  }
}
