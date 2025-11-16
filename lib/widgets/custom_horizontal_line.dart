import 'package:flutter/material.dart';

class CustomHorizontalLine extends StatelessWidget {
  final double thickness;
  final Color color;
  final double indent;
  final double endIndent;

  // Constructor
  const CustomHorizontalLine({
    Key? key,
    this.thickness = 15.0,
    this.color =  const Color(0xFFEEEEEE),

    this.indent = 0.0,
    this.endIndent = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Divider(
        color: color,
        thickness: thickness,
        indent: indent,
        endIndent: endIndent,
      ),
    );
  }
}
