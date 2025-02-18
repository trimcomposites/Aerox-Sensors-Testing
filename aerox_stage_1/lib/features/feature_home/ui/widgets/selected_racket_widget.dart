import 'package:aerox_stage_1/common/ui/resources.dart';
import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/features/feature_racket/feature_details/ui/racket_image.dart';
import 'package:flutter/material.dart';

class SelectedRacketWidget extends StatelessWidget {
  const SelectedRacketWidget({
    super.key,
    required this.racket,
  });

  final Racket racket;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none, 
      children: [
        Positioned(
          top: -70, 
          child: Container(
            width: 300,
            child: Text(
              racket.nombrePala,
              style: const TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.w500
              ),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        RacketImage(
          isRacketSelected: true,
          racket: racket,
          height: homePageRacketImgSize,
        ),
      ],
    );
  }
}
