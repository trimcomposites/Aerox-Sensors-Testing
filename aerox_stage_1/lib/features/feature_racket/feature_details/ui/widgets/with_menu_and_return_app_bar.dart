import 'package:flutter/material.dart';

class WithMenuAndReturnAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WithMenuAndReturnAppBar({
    super.key, 
    required this.onback
  });

  final void Function()? onback;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 300,
      leading:
      Container(
        //TODO: AÑADIR TEXTO CONFIG
        child: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 30,),
          onPressed: onback
        ),
      ), 
      title: Column(
        children: [
          Container(
            color: Colors.red,
            margin: EdgeInsets.only(  bottom: 40 ),
            height: 10,
            child: Image.asset('assets/Logotipo-Aerox-Negro.jpg',)
          ),

        ],
      ),
      actions: [

      ]
    );
  }
  
  @override
  Size get preferredSize => Size.fromHeight(80); 
}
