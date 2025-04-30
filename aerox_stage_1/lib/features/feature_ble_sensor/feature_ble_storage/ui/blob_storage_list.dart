import 'package:aerox_stage_1/common/ui/loading_indicator.dart';
import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_ble_storage/blocs/ble_storage/ble_storage_bloc.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_ble_storage/ui/ble_storage_loading_indicator.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_ble_storage/ui/blob_list.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_blob_database/blocs/blob_database/blob_database_bloc.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/blocs/selected_entity_page/selected_entity_page_bloc.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/feature_blob_database/ui/by_exact_date_blob_filter.dart';
import 'package:aerox_stage_1/features/feature_home/ui/home_page_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class BlobStorageList extends StatelessWidget {
  const BlobStorageList({super.key});

  @override
  Widget build(BuildContext context) {
    final bleStorageBloc = BlocProvider.of<BleStorageBloc>(context);
    final blobsNum = bleStorageBloc.state.blobsBySensor.values.expand((list) => list).toList().length;
    
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                  BlocBuilder<BleStorageBloc, BleStorageState>(
                    builder: (context, state) {
                      return 
                      state.uiState.status != UIStatus.loading
                      ? Center(
                        child: Column( 
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.add_chart, color: Colors.green, size: 25,),
                            Text( '¡Se han leído correctamente ${blobsNum} Blobs!', style: TextStyle( fontSize: 20 ), textAlign: TextAlign.center, ),
                        ],
                                            ),
                      )
                    : Center(child: Text( 'Leyendo Blobs de Storage...', style: TextStyle( fontSize: 20 ), ));
                  },
                ),

                BlobList(),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
