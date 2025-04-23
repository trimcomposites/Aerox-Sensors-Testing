import 'dart:io';

import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/domain/models/parsed_blob.dart';
import 'package:aerox_stage_1/domain/use_cases/blob_database/export_to_csv_blob_list_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/blob_database/get_all_blobs_from_db_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/storage/upload_blobs_to_storage_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'blob_database_event.dart';
part 'blob_database_state.dart';

class BlobDatabaseBloc extends Bloc<BlobDatabaseEvent, BlobDatabaseState> {
  
  final GetAllBlobsFromDbUsecase getAllBlobsFromDbUsecase;
  final ExportToCsvBlobListUsecase exportToCsvBlobListUsecase;
  final UploadBlobsToStorageUsecase uploadBlobsToStorageUsecase;
  
  BlobDatabaseBloc({
    required this.getAllBlobsFromDbUsecase,
    required this.exportToCsvBlobListUsecase,
    required this.uploadBlobsToStorageUsecase
  }) : super(BlobDatabaseState( uiState: UIState.idle() )) {
    on<OnReadBlobDatabase>((event, emit) async {
      // ignore: avoid_single_cascade_in_expression_statements
      await getAllBlobsFromDbUsecase.call()..fold(
        (l) => emit( state.copyWith( uiState: UIState.error( 'Error al obtener los Blobs de la base de datos.' ) ) ) , 
        (r) => emit( state.copyWith( blobs: r, filteredBlobs: r ) )
      );
    });
    on<OnExportToCSVFilteredBlobs>((event, emit) async{
      // ignore: avoid_single_cascade_in_expression_statements
      await exportToCsvBlobListUsecase.call( state.blobs )..fold(
        (l) => emit( state.copyWith( uiState: UIState.error( 'Error al obtener los Blobs de la base de datos.' ) ) ) , 
        (r) {
          add(OnReadBlobDatabase());
        }
      );
    });
    on<OnUploadBlobsToStorage>((event, emit) async {
      try {
        final files = event.blobs
            .where((blob) => blob.path != null)
            .map((blob) => File(blob.path!))
            .where((file) => file.existsSync()) 
            .toList();

        if (files.isEmpty) {
          emit(state.copyWith(
            uiState: UIState.error('No se encontraron archivos válidos para subir.'),
          ));
          return;
        }

        final result = await uploadBlobsToStorageUsecase.call(files);
        result.fold(
          (l) => emit(state.copyWith(
            uiState: UIState.error('Error al subir los Blobs al almacenamiento.'),
          )),
          (r) {
          },
        );
      } catch (e) {
        emit(state.copyWith(
          uiState: UIState.error('Error inesperado al subir los blobs: $e'),
        ));
      }
    });

    on<OnAddBlobToSelectedList>((event, emit) {
      final updatedList = List<ParsedBlob>.from(state.selectedBlobs);
      if (!updatedList.contains(event.blob)) {
        updatedList.add(event.blob);
        emit(state.copyWith(selectedBlobs: updatedList));
      }
    });

    on<OnRemoveBlobFromSelectedList>((event, emit) {
      final updatedList = List<ParsedBlob>.from(state.selectedBlobs);
      updatedList.remove(event.blob);
      emit(state.copyWith(selectedBlobs: updatedList));
    });
    on<OnResetBlobSelectedList>((event, emit) {
      emit(state.copyWith(selectedBlobs: []));
    });
    on<OnAddAllBlobsToSelectedList>((event, emit) {
      emit(state.copyWith(selectedBlobs: state.filteredBlobs));
    });
   on<OnFilterDatabaseBlobsByExactDate>((event, emit) {
      final filtered = state.blobs.where((b) {
        final created = b.createdAt;
        return created != null &&
          created.year == event.exactDate.year &&
          created.month == event.exactDate.month &&
          created.day == event.exactDate.day;
      });

      final combined = {...filtered, ...state.selectedBlobs}.toList();

      emit(state.copyWith(filteredBlobs: combined));
    });


  }
}
