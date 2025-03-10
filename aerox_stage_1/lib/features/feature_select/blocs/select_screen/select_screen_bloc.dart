import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/download_racket_images_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/get_rackets_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/racket/select_racket_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'select_screen_event.dart';
part 'select_screen_state.dart';

class SelectScreenBloc extends Bloc<SelectScreenEvent, SelectScreenState> {
final GetRacketsUseCase getRacketsUseCase;
final SelectRacketUseCase selectRacketUseCase;
final DownloadRacketImagesUsecase downloadRacketImagesUsecase;
  SelectScreenBloc({
    required this.getRacketsUseCase,
    required this.selectRacketUseCase,
    required this.downloadRacketImagesUsecase
  }) : super(SelectScreenState( uiState: UIState.loading()  )){
 on<OnGetRacketsSelect>((event, emit) async {
    emit(state.copyWith(uiState: UIState.loading()));

    final result = await getRacketsUseCase();

    await result.fold(
      (l) async {
        emit(state.copyWith(rackets: null, uiState: UIState.idle()));
      },
      (r1) async {
        final downloadImagesResult = await downloadRacketImagesUsecase();

        await downloadImagesResult.fold(
          (l) async {
            emit(state.copyWith(rackets: null, uiState: UIState.idle()));
            },
          (r3) async {

            final updatedResult = await getRacketsUseCase();

              updatedResult.fold(
                (l) => emit(state.copyWith(rackets: null, uiState: UIState.idle())),
                  (updatedRackets) {
                    if (!emit.isDone) {
                    emit(state.copyWith(rackets: updatedRackets, uiState: UIState.success()));
                }
              },
            );
          },
        );
      }
    );
  });


    on<OnSelectRacketSelect>((event, emit)async{
      // ignore: avoid_single_cascade_in_expression_statements
      await selectRacketUseCase( event.racket )..fold(
      (l) => emit( state.copyWith( rackets: null) ),
      (r) => emit( state.copyWith( rackets: null, uiState: UIState.success( next: '/home' ) ) )
      );
    },);
  
  }
}
