import 'package:flutter/material.dart';

class CustomVerticalLine extends StatelessWidget {
  final double height;
  final Color color;

  const CustomVerticalLine({
    Key? key,
    required this.height,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height, // Height of the vertical line
      width: 2, // The thickness of the line
      color: color, // Color of the vertical line
    );
  }
}
