import 'package:flutter/material.dart';

class LoadingDetailsScreen extends StatelessWidget {
  const LoadingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CircularProgressIndicator(),
    );
  }
}