import 'dart:io';

import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/domain/models/error_log.dart';
import 'package:aerox_stage_1/domain/models/parsed_blob.dart';
import 'package:aerox_stage_1/domain/use_cases/blob_database/export_to_csv_blob_list_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/blob_database/get_all_blobs_from_db_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/blob_database/get_all_error_logs_from_db_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/storage/upload_blobs_to_storage_usecase.dart';
import 'package:aerox_stage_1/features/feature_storage/repository/upload_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';

part 'blob_database_event.dart';
part 'blob_database_state.dart';

class BlobDatabaseBloc extends Bloc<BlobDatabaseEvent, BlobDatabaseState> {
  
  final GetAllBlobsFromDbUsecase getAllBlobsFromDbUsecase;
  final ExportToCsvBlobListUsecase exportToCsvBlobListUsecase;
  final UploadBlobsToStorageUsecase uploadBlobsToStorageUsecase;
  final GetAllErrorLogsFromDbUsecase getAllErrorLogsFromDbUsecase;
  
  BlobDatabaseBloc({
    required this.getAllBlobsFromDbUsecase,
    required this.exportToCsvBlobListUsecase,
    required this.uploadBlobsToStorageUsecase,
    required this.getAllErrorLogsFromDbUsecase
  }) : super(BlobDatabaseState( uiState: UIState.idle() )) {
    on<OnReadBlobDatabase>((event, emit) async {
      // ignore: avoid_single_cascade_in_expression_statements
      await getAllBlobsFromDbUsecase.call()..fold(
        (l) => emit( state.copyWith( uiState: UIState.error( 'Error al obtener los Blobs de la base de datos.' ) ) ) , 
        (r) => emit( state.copyWith( blobs: r, filteredBlobs: r ) )
      );
    });
  on<OnUploadErrorLogs>((event, emit) async {
    final logs = state.selectedLogs;
    if (logs.isEmpty) {
      emit(state.copyWith(uiState: UIState.error("No hay logs seleccionados.")));
      return;
    }

    emit(state.copyWith(uiState: UIState.loading()));

    try {
      final List<FileWithPath> txtFiles = [];

      for (final log in logs) {
        final dir = await getApplicationDocumentsDirectory();
        final fileName = '${log.date.toIso8601String()}_${log.id}.txt';
        final filePath = '${dir.path}/$fileName';
        final file = File(filePath);

        await file.writeAsString(log.content);

        final folder = DateFormat('yyyy-MM-dd').format(log.date);
        txtFiles.add(FileWithPath(file: file, path: folder));
      }

      final result = await uploadBlobsToStorageUsecase.call(txtFiles);

      result.fold(
        (err) {
          print('❌ Error al subir logs: ${err.toString()}');
          emit(state.copyWith(uiState: UIState.error('Error al subir los logs de error.')));
        },
        (_) {
          print('✅ Logs subidos correctamente.');
          emit(state.copyWith(uiState: UIState.success()));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        uiState: UIState.error('Error inesperado al subir logs: $e'),
      ));
    }
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
    on<OnGetErrorLogs>((event, emit) async{
      // ignore: avoid_single_cascade_in_expression_statements
      await getAllErrorLogsFromDbUsecase.call( )..fold(
        (l) => emit( state.copyWith( uiState: UIState.error( 'Error al obtener los Blobs de la base de datos.' ) ) ) , 
        (r) {
          emit( state.copyWith( errorLogs: r ) );
        }
      );
    });

on<OnUploadBlobsToStorage>((event, emit) async {
  try {
    final dir = await getApplicationDocumentsDirectory(); 
    final List<FileWithPath> filesWithPaths = [];

    for (final blob in event.blobs) {
      final fileName = blob.path;
      final createdAt = blob.createdAt;

      if (fileName == null || createdAt == null) {
        print('❌ Blob descartado: path o createdAt nulos');
        continue;
      }

      final fullPath = '${dir.path}/$fileName';
      final file = File(fullPath);
      final exists = await file.exists();

      if (!exists) {
        print('❌ Archivo no existe: $fullPath');
        continue;
      }

      final folder = DateFormat('yyyy-MM-dd').format(createdAt);
      print('✅ Archivo válido: $fullPath | Carpeta: $folder');

      filesWithPaths.add(FileWithPath(file: file, path: folder));
    }

    if (filesWithPaths.isEmpty) {
      emit(state.copyWith(
        uiState: UIState.error('No se encontraron archivos válidos para subir.'),
      ));
      return;
    }

    final result = await uploadBlobsToStorageUsecase.call(filesWithPaths);
    result.fold(
      (l) {
        print('❌ Fallo al subir archivos: ${l.toString()}');
        emit(state.copyWith(
          uiState: UIState.error('Error al subir los Blobs al almacenamiento.'),
        ));
      },
      (r) {
        print('✅ Todos los archivos subidos con éxito.');
        emit(state.copyWith(
          uiState: UIState.success(),
        ));
      },
    );
  } catch (e) {
    print('❌ Excepción inesperada: $e');
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
    on<OnFilterDatabaseBlobsByExactDate>((event, emit) async {
      final List<ParsedBlob> filtered = [];

      for (final b in state.blobs) {
        final created = b.createdAt;
        if (created != null &&
            created.year == event.exactDate.year &&
            created.month == event.exactDate.month &&
            created.day == event.exactDate.day) {
          filtered.add(b);
        }
      }

      final combined = {...filtered, ...state.selectedBlobs}.toList();

      final List<ErrorLog> matchedLogs = state.errorLogs.where((log) {
        final logDate = log.date;
        return logDate.year == event.exactDate.year &&
            logDate.month == event.exactDate.month &&
            logDate.day == event.exactDate.day;
      }).toList();

      emit(state.copyWith(
        filteredBlobs: combined,
        selectedLogs: matchedLogs,
      ));
    });

    on<OnFilterDatabaseBlobsUntilDate>((event, emit) {
      final filtered = state.blobs.where((b) {
        final created = b.createdAt;
        return created != null && created.isBefore(event.untilDate.add(Duration(days: 1)));
      });

      final combined = {...filtered, ...state.selectedBlobs}.toList();
      emit(state.copyWith(filteredBlobs: combined));
    });

  }
}
