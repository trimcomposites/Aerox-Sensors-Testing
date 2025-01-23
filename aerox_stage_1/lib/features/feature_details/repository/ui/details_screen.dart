import 'package:aerox_stage_1/features/feature_details/repository/ui/details_screen_view.dart';
import 'package:flutter/material.dart';

import '../../../feature_login/ui/login_barrel.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(  toolbarHeight: 10,), //temp
      body: Stack(
        children: [
          BackgroundGradient(),
          DetailsScreenView(),
        ],
      )
    );
  }
}
