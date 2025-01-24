import 'package:flutter/material.dart';

class WithMenuAndReturnAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WithMenuAndReturnAppBar({
    super.key, 
  });
  @override
  Widget build(BuildContext context) {
    return AppBar(
      
      backgroundColor: Colors.black,
      toolbarHeight: 200,
      leading: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20,),
            onPressed: () {
            },
            
          ), 
        ],
      ),
      title: Container(
        height: 13,
        child: Image.asset('assets/Logotipo-Aerox-Blanco.png',)
      ),
      actions: [
        IconButton(
          onPressed: (){}, 
          icon: Icon( Icons.menu, color: Colors.white, size: 40, )
        )
      ],
    );
  }
  
  @override

  Size get preferredSize =>  Size(40, 60);
}
