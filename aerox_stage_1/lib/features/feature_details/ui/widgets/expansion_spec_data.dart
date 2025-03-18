import 'package:aerox_stage_1/domain/models/racket.dart';
import 'package:aerox_stage_1/domain/models/racket_extension.dart';
import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:aerox_stage_1/features/feature_details/ui/widgets/technical_specs_text.dart';

import 'package:flutter/material.dart';

class ExpansionSpecData extends StatefulWidget {
  const ExpansionSpecData({super.key, required this.racket, required this.text});
  final Racket racket;
  final String text;
  @override
  _ExpansionSpecDataState createState() => _ExpansionSpecDataState();
}

class _ExpansionSpecDataState extends State<ExpansionSpecData> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final specs = widget.racket.getSpecs();
    return Container(
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            color: Colors.black,  
            width: 0.5,
          )
        ),
      ),
      child: ExpansionTile(
        title: Text(widget.text, maxLines: 1, textAlign: TextAlign.start, style: TextStyle( fontSize: 14 ),),
        onExpansionChanged: (bool expanded) {
          setState(() {
            _isExpanded = expanded; 
          });
        },
        trailing: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all( color: Colors.black, width: 1 )
        ),
        child: Icon(
          _isExpanded ? Icons.remove : Icons.add,  
          color: Colors.black,
        ),
      ),
      
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(  left: 30 ),
            child: GridView.builder(
              shrinkWrap: true, 
              physics: NeverScrollableScrollPhysics(), 
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 40, 
                mainAxisSpacing: 10,
                childAspectRatio: 1.8,
              ),
              itemCount: specs.length,
              itemBuilder: (context, index) {
                
                return TechnicalSpecsText( title: specs[index].key, value: specs[index].value, );
              },
              ),
          ),
        ],
      ),
    );
  }
}

class TechnicalListRow extends StatelessWidget {
  const TechnicalListRow({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Wrap(

        spacing: 40,
        children: children,
      ),
    );
  }
}
  