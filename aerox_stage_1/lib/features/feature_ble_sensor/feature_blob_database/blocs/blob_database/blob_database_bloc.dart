import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/domain/models/parsed_blob.dart';
import 'package:aerox_stage_1/domain/use_cases/blob_database/export_to_csv_blob_list_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/blob_database/get_all_blobs_from_db_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'blob_database_event.dart';
part 'blob_database_state.dart';

class BlobDatabaseBloc extends Bloc<BlobDatabaseEvent, BlobDatabaseState> {
  
  final GetAllBlobsFromDbUsecase getAllBlobsFromDbUsecase;
  final ExportToCsvBlobListUsecase exportToCsvBlobListUsecase;
  
  BlobDatabaseBloc({
    required this.getAllBlobsFromDbUsecase,
    required this.exportToCsvBlobListUsecase
  }) : super(BlobDatabaseState( uiState: UIState.idle() )) {
    on<OnReadBlobDatabase>((event, emit) async {
      // ignore: avoid_single_cascade_in_expression_statements
      await getAllBlobsFromDbUsecase.call()..fold(
        (l) => emit( state.copyWith( uiState: UIState.error( 'Error al obtener los Blobs de la base de datos.' ) ) ) , 
        (r) => emit( state.copyWith( blobs: r ) )
      );
    });
    on<OnExportToCSVFilteredBlobs>((event, emit) async{
      // ignore: avoid_single_cascade_in_expression_statements
      await exportToCsvBlobListUsecase.call( state.blobs )..fold(
        (l) => emit( state.copyWith( uiState: UIState.error( 'Error al obtener los Blobs de la base de datos.' ) ) ) , 
        (r) {
          print(r);
        }
      );
    });
  }
}
