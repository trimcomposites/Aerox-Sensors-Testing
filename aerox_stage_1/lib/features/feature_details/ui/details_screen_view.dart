import 'package:aerox_stage_1/common/ui/resources.dart';
import 'package:aerox_stage_1/common/ui/small_app_button.dart';
import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/common/ui/selected_racket_widget.dart';
import 'package:aerox_stage_1/features/feature_racket/blocs/racket/racket_bloc.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:aerox_stage_1/features/feature_comments/ui/add_comment_button.dart';
import 'package:aerox_stage_1/features/feature_comments/ui/comment_section.dart';
import 'package:aerox_stage_1/features/feature_3d/ui/racket_3d_model.dart';
import 'package:aerox_stage_1/features/feature_details/ui/widgets/racket_specs.dart';
import 'package:aerox_stage_1/features/feature_details/ui/widgets/upper_info_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailsScreenView extends StatelessWidget {
  const DetailsScreenView({
    super.key, 
    required this.rackets, 
    required this.isLoading,
    this.onPressedSelectRacket, this.onPressedDeselectRacket
    });

  final List<Racket> rackets;
  final bool isLoading;
  final void Function( Racket )? onPressedSelectRacket;
  final void Function( )? onPressedDeselectRacket;
  @override
  Widget build(BuildContext context) {
    final PageController _pageController = PageController();
    final ValueNotifier<int> racketIndexNotifier = ValueNotifier<int>(0); 
    final bool isRacketSelected = rackets.length == 1;
    print(rackets[0].model ?? 'no hay modelo');
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric( horizontal: 30),
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: UpperInfoText(),
              ),
              SizedBox( height: 30, ),
              Stack(
                alignment: Alignment.bottomCenter,
                children:[
                  Container(
                    margin: EdgeInsets.zero,
                    height: 600,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: isRacketSelected ? 1 : rackets.length,
                      onPageChanged: (int index) {
                        racketIndexNotifier.value = index; 
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return SelectedRacketWidget(
                          ignorePointer: true,
                          rotateSpeed: 100,
                          racket: rackets[index],
                          textPosition: -10,
                          height: 600,
                          );
                      }
                    ),
                  ),
                  Positioned(
                    bottom: 125,
                    child: SmallAppButton(
                    onTap: () {
                      if (isRacketSelected) {
                        onPressedDeselectRacket?.call();
                      } else {
                        onPressedSelectRacket?.call(rackets[racketIndexNotifier.value]);
                      }
                    },
                    text: !isRacketSelected ? 'Seleccionar raqueta' : 'Cancelar seleccion',
                                    ),
                  ),
                ] 
              ),
              SizedBox( height: 25, ),
              RacketSpecs(
                racketIndexNotifier: racketIndexNotifier,
                rackets: rackets,
                showAdvancedSpecs: isRacketSelected ? false : true,
              ),
              isRacketSelected

              ? CommentSection( racketId: rackets[0].docId, )

              : Container()
            ],
          ),
        ),
      ),
    );
  }
}
