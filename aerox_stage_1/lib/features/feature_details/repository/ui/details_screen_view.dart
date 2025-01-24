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
                SpecsDataText( data: [ 'Weight', '343,756g' ],),
                SpecsDataText( data: [ 'Balance', '343,756g', 'HeadLight' ], ),
                SpecsDataText( data: [ 'Weight', '343,756g', '>Numero => Potencia' ], ),

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
                Text( data[0], style: TextStyle(  color: Colors.white), ),
                SizedBox( width: 50, ),
                Text( data[1], style: TextStyle(  color: Colors.white), ),
              ],
            ),
            SizedBox(width: 50,),
            data.length>2
            ? Text( data[2], style: TextStyle(  color: Colors.white), )
            : SizedBox(width: 10,)
          ],
        ),
      
    );
  }
}