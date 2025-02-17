import 'package:flutter/material.dart';

PreferredSizeWidget BackButtonAppBar( void Function()? onPressed ) {
  return AppBar(
    toolbarHeight: 200,
    backgroundColor: Colors.transparent,
    leading: Padding(
      padding: const EdgeInsets.only(left: 16),
      child: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 40,), // Nuevo icono y color
        onPressed: onPressed
      ),
    ),
    elevation: 0, 
  );
}