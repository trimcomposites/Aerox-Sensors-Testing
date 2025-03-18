import 'package:aerox_stage_1/common/ui/resources.dart';
import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/features/feature_3d/ui/racket_3d_model.dart';
import 'package:flutter/material.dart';

class SelectedRacketWidget extends StatelessWidget {
  SelectedRacketWidget({
    super.key,
    required this.racket,
    this.textPosition = -30,
    this.height = 700, required this.ignorePointer, required this.rotateSpeed,
    this.textFontSize  = 40
  });

  final Racket racket;
  double textPosition;
  final double height;
  final bool ignorePointer;
  final int rotateSpeed;
  final double textFontSize;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none, 
      children: [
        Positioned(
          top: textPosition, 
          child: Container(
            width: 325,
            child: Text(
              racket.racketName,
              style: TextStyle(
                fontSize: textFontSize,
                fontWeight: FontWeight.w500
              ),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Positioned(
          top: 30,
          child: Racket3dModel(
            isRacketSelected: true,
            racket: racket,
            height: height,
            rotateSpeed: rotateSpeed,
            ignorePointer: ignorePointer,
          ),
        ),
      ],
    );
  }
}
