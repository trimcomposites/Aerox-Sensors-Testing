import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/features/feature_3d/blocs/bloc/3d_bloc.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
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
    final Flutter3DController controller = Flutter3DController();
    final model3dBloc = BlocProvider.of<Model3DBloc>(context);
    final widthMultiplier = ignorePointer
      ? 1.1
      : 1.0;
    final modelWidth = MediaQuery.of(context).size.width / widthMultiplier;

    return IgnorePointer(
      ignoring: ignorePointer,
      child: Container(
        height: 600,
        width: modelWidth,
        child: BlocBuilder<Model3DBloc, Model3DState>(
          builder: (context, state) {
            if (state.uiState.status == UIStatus.error) {
              print('modelo: ' + racket.model);
              return Image.asset(
                racket.image,
                fit: BoxFit.fill,
              );
            }
            return Stack(
              alignment: Alignment.center,
              children: [
                Flutter3DViewer(
                  activeGestureInterceptor: ignorePointer,
                  progressBarColor: Colors.transparent,
                  enableTouch: true,
                  onProgress: (double progressValue) {
                    if (progressValue < 1.0) {
                      model3dBloc.add(OnStartLoadingModel3d());
                    }
                    debugPrint('model loading progress: $progressValue');
                  },
                  onLoad: (String modelAddress) {
                    model3dBloc.add(OnStopLoadingModel3d());
                    debugPrint('model loaded: $modelAddress');
                    //controller.setCameraOrbit(5.0, 0, 0);
                    controller.playAnimation();
                  },
                  onError: (String error) {
                    model3dBloc.add(OnStartErrorModel3d());
                    debugPrint('model failed to load: $error');
                  },
                  src:
                  racket.model.isEmpty 
                  ? 'assets/3d/20250222_LABT003_3D_GLB_V2.glb'
                  : racket.model,
                  controller: controller,
                ),
                if (state.uiState.status == UIStatus.loading)
                  Container(
                    width: modelWidth/1.2,
                    child: Image.asset(
                      fit: BoxFit.cover,
                      racket.image,
                    ),
                  )
              ],
            );
          },
        ),
      ),
    );
  }
}
