import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_sharing/custom_assets/app_image.dart';

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
    this.fontSize = 32,      // Default font size (kept for backward compatibility)
    this.backgroundColor = Colors.transparent, // Default transparent for image
    this.textColor = Colors.white,  // Default text color (kept for backward compatibility)
    this.text = 'Logo',      // Default text (kept for backward compatibility)
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Image.asset(
          AppImage.davidLogo,
          width: width.w,
          height: height.h,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
