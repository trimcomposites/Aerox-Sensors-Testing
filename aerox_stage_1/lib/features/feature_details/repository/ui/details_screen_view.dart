import 'package:flutter/material.dart';

class DetailsScreenView extends StatelessWidget {
  const DetailsScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size.width;
    return SingleChildScrollView( 

    child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 30
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: Text( 'TU PALA AEROX', style: TextStyle( color: Colors.white, fontSize: 20 ), )),
        
            SizedBox( height: 450, ),
        
            Text( 'AEROX Alpha ProShield', style: TextStyle( color: Colors.white, fontSize: 23, ), textAlign: TextAlign.start, ),
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: Text(' Datos tecnicos ', style: TextStyle( color: Colors.white ),),
              leading: Icon( Icons.arrow_drop_up, color: Colors.white, ),
              trailing: SizedBox.shrink(),
              children: [
                SpecsDataText( data: [ 'Weight', '343,756g' ], deviceSize: deviceSize,),
                SpecsDataText( data: [ 'Balance', '343,756g', 'HeadLight' ], deviceSize: deviceSize,),
              ],
            )
            
          ]
        ),
      ),
    )
    );
  }
}

class SpecsDataText extends StatelessWidget {
  const SpecsDataText({
    super.key, 
    this.data = const [], required this.deviceSize
  });
  final List<String> data;
  final double deviceSize;
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only( bottom: 10 ), 
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,

      children: [
        for (String text in data)
        Container(
          child: Text(text, style: TextStyle( color: Colors.white ),),
          width: 100,
          ),

      ]
    )
    );
  }
}