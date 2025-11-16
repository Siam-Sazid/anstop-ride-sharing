import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/utils/app_colors.dart';
import '../../../widgets/custom_vertical_line.dart';

class PaymentTripItems extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool hasVerticalLine;
  final IconData? icon;
  final String distanceOrTime; // 'Distance' or 'Travel Time' info (like '48 km' or '50 min')

  const PaymentTripItems({
    Key? key,
    required this.title,
    required this.subtitle,
    this.hasVerticalLine = false,
    this.icon,
    this.distanceOrTime = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Title Section
        Container(
          color: AppColors.white,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sp),
            child: Row(
              children: [
                if (icon != null)
                  Icon(icon, color: AppColors.primaryColor),
                if (icon != null) SizedBox(width: 5.sp),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),

        // Vertical Line (Optional)
        if (hasVerticalLine)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sp),
            child: CustomVerticalLine(
              height: 30.h,
              color: Colors.black,
            ),
          ),

        // Distance or Time Section
        if (distanceOrTime.isNotEmpty)
          Container(
            color: AppColors.white,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 15.sp),
                  ),
                  Spacer(),
                  Text(
                    distanceOrTime,
                    style: TextStyle(fontSize: 20.sp),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
