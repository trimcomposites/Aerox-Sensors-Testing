import 'package:aerox_stage_1/features/feature_details/repository/ui/details_screen_view.dart';
import 'package:aerox_stage_1/features/feature_details/repository/ui/with_menu_and_return_app_bar.dart';
import 'package:flutter/material.dart';

import '../../../feature_login/ui/login_barrel.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: WithMenuAndReturnAppBar(),
          body: Stack(
            children: [
              BackgroundGradient(),
              DetailsScreenView(),
            ],
          )
        ),

    );
  }
}
