import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_sharing/widgets/home_links/home_links.dart'; // Assuming you're using this for screen responsiveness

class LogoWidget extends StatelessWidget {
  final double width;
  final double height;
  final double fontSize;
  final Color backgroundColor;
  final Color textColor;
  final String text;

  // Constructor with optional named parameters
  const LogoWidget({
    super.key,
    this.width = 120,        // Default width
    this.height = 120,       // Default height
    this.fontSize = 32,      // Default font size
    this.backgroundColor = AppColors.primaryColor, // Default primary color
    this.textColor = Colors.white,  // Default text color
    this.text = 'Logo',      // Default text
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: width.w,        // Use dynamic width
        height: height.h,      // Use dynamic height
        decoration: BoxDecoration(
          color: backgroundColor,  // Use dynamic background color
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          text,  // Use dynamic text
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,   // Use dynamic text color
            fontSize: fontSize.sp, // Use dynamic font size
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
