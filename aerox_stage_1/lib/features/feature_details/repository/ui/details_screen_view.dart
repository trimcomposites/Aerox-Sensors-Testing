import 'package:flutter/material.dart';

class DetailsScreenView extends StatelessWidget {
  const DetailsScreenView({super.key});

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Column(
        children: [
          Text( 'TU PALA AEROX', style: TextStyle( color: Colors.white, fontSize: 20 ), ),
      
          SizedBox( height: 500, ),
      
          Text( 'AEROX Alpha ProShield', style: TextStyle( color: Colors.white, fontSize: 20, ), textAlign: TextAlign.start, ),
          
        ]
      ),
    );
  }
}