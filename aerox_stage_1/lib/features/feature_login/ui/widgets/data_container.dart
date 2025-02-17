import 'package:flutter/material.dart';

class DataContainer extends StatelessWidget {
  const DataContainer({super.key, this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 325,
      height: 100,
      child: child,
    );
  }
}