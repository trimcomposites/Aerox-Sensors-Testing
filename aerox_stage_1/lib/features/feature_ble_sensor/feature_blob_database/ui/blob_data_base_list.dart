import 'package:aerox_stage_1/features/feature_ble_sensor/feature_blob_database/blocs/blob_database/blob_database_bloc.dart';
import 'package:aerox_stage_1/features/feature_home/ui/home_page_barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlobDataBaseList extends StatelessWidget {
  const BlobDataBaseList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<BlobDatabaseBloc, BlobDatabaseState>(
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.blobs.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child: Text( ' BLOB ${index} : ${ state.blobs[index].content.first['timestamp'] } PATH: ${ state.blobs[index].path  } ' ),
              );
            },
          );
        },
      ),
    );
  }
}