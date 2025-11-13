import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomLocationButton extends StatelessWidget {
  final String imageUrl; // URL or asset for the image
  final String mainText; // Text for the first, larger text
  final String subText;  // Text for the second, smaller text
  final VoidCallback onTap; // GestureDetector callback

  const CustomLocationButton({
    Key? key,
    required this.imageUrl,
    required this.mainText,
    required this.subText,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,  // The onTap functionality for the gesture detector
      child: Container(
        color: Colors.transparent,  // Makes the background transparent
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Circular Image
            ClipOval(
              child: Image.network(
                imageUrl,  // Use image asset or network image
                width: 50.0, // Size of the circular image
                height: 50.0, // Size of the circular image
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10), // Space between image and text column
            // Column with two Text widgets
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mainText,  // Larger text
                  style: TextStyle(
                    fontSize: 15.sp,  // Larger font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subText,  // Smaller text
                  style: TextStyle(
                    fontSize: 12.sp,  // Smaller font size
                    color: Colors.grey,  // Lighter color for smaller text
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}