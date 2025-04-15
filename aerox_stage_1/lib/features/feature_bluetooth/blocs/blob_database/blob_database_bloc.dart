import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'blob_database_event.dart';
part 'blob_database_state.dart';

class BlobDatabaseBloc extends Bloc<BlobDatabaseEvent, BlobDatabaseState> {
  BlobDatabaseBloc() : super(BlobDatabaseState( uiState: UIState.idle() )) {
    on<BlobDatabaseEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<OnReadBlobDatabase>((event, emit) {
      // TODO: implement event handler
    });
    // on<BlobDatabaseEvent>((event, emit) {
    //   // TODO: implement event handler
    // });
  }
}
