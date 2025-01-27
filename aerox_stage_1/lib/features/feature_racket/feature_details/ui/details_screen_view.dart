import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/features/feature_racket/blocs/racket/racket_bloc.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
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

    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  isRacketSelected ? 'TU PALA AEROX' : 'SELECCIONA TU PALA',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              Container(
                height: 450,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: isRacketSelected ? 1 : rackets.length,
                  onPageChanged: (int index) {
                    racketIndexNotifier.value = index; 
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Image.network(
                      isRacketSelected ? rackets[0].img : rackets[index].img,
                      height: 450,
                    );
                  },
                ),
              ),
              Text(
                'AEROX Alpha ProShield',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                ),
                textAlign: TextAlign.start,
              ),
              AppButton(
                onPressed: () {
                  if (isRacketSelected) {
                    onPressedDeselectRacket?.call();
                  } else {
                    onPressedSelectRacket?.call(rackets[racketIndexNotifier.value]);
                  }
                },
                text: !isRacketSelected ? 'Seleccionar raqueta' : 'Cancelar seleccion',
                backgroundColor: appYellowColor,
                showborder: false,
                fontColor: Colors.black,
              ),
              ValueListenableBuilder<int>(
                valueListenable: racketIndexNotifier,
                builder: (context, racketIndex, child) {
                  return ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    title: Text(
                      ' Datos tecnicos ',
                      style: TextStyle(color: Colors.white),
                    ),
                    leading: Icon(
                      Icons.arrow_drop_up,
                      color: Colors.white,
                    ),
                    trailing: SizedBox.shrink(),
                    children: [
                      SpecsDataText(
                        data: ['Weight', rackets[racketIndex].weight.toString()],
                      ),
                      SpecsDataText(
                        data: ['Balance', rackets[racketIndex].balance.toString()],
                      ),
                      SpecsDataText(
                        data: ['Pattern', rackets[racketIndex].pattern],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SpecsDataText extends StatelessWidget {
  const SpecsDataText({
    super.key,
    this.data = const [],
  });

  final List<String> data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                data[0],
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                width: 50,
              ),
              Text(
                data[1],
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          SizedBox(
            width: 50,
          ),
          data.length > 2
              ? Text(
                  data[2],
                  style: TextStyle(color: Colors.white),
                )
              : SizedBox(
                  width: 10,
                )
        ],
      ),
    );
  }
}
