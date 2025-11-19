import 'package:flutter/material.dart';

class CarDetailsWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final Color backgroundColor; // Color parameter

  // Constructor to accept title, subtitle, image path, and background color
  const CarDetailsWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.backgroundColor, // Receive the color as parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor, // Use the passed background color
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black, // White text color for contrast
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.black), // Light color for subtitle
        ),
        trailing: Image.asset(imagePath), // Car image
      ),
    );
  }
}
