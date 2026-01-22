import 'package:flutter/material.dart';
import 'package:ride_sharing/custom_assets/app_image.dart';

class CarDetailsWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final Color backgroundColor;
  final bool isNetworkImage;

  const CarDetailsWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.backgroundColor,
    this.isNetworkImage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.black),
        ),
        trailing: isNetworkImage
            ? Image.network(
                imagePath,
                width: 80,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(AppImage.carsSideView);
                },
              )
            : Image.asset(imagePath),
      ),
    );
  }
}
