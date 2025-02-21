import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/features/feature/3d/blocs/bloc/3d_bloc.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class Racket3dModel extends StatelessWidget {
  const Racket3dModel({
    super.key,
    required this.isRacketSelected,
    required this.racket,
    required this.height,
    required this.ignorePointer,
    required this.rotateSpeed,
  });

  final bool isRacketSelected;
  final Racket racket;
  final double height;
  final bool ignorePointer;
  final int rotateSpeed;

  @override
  Widget build(BuildContext context) {
    final model3dBloc = BlocProvider.of<Model3DBloc>( context );
    return IgnorePointer(
      ignoring: ignorePointer,
      child: Container(
          height: 600,
          width: 400,
          child: BlocBuilder<Model3DBloc, Model3DState>(
            builder: (context, state) {
              return state.uiState.status == UIStatus.error
              ? CircularProgressIndicator()
              : Stack(
                alignment: Alignment.center,
                children: [
                  Flutter3DViewer(
                    activeGestureInterceptor: true,
                    progressBarColor: Colors.orange,
                    enableTouch: true,
                  
                    onProgress: (double progressValue) {
                      model3dBloc.add( OnStartLoadingModel3d() );
                      debugPrint('model loading progress : $progressValue');
                    },
                    onLoad: (String modelAddress) {
                      model3dBloc.add( OnStopLoadingModel3d() );
                      debugPrint('model loaded : $modelAddress');
                    },
                    onError: (String error) {
                      model3dBloc.add( OnStartErrorModel3d() );
                      debugPrint('model failed to load : $error');
                    },
                    src: 'assets/3d/adidas_padel_2023.glb',
                  ),
                  if (state.uiState.status == UIStatus.loading)
                  CircularProgressIndicator()
                ],
              );
            },
          )),
    );
  }
}
