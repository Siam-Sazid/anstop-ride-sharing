import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/utils/app_colors.dart';
import '../../../widgets/custom_vertical_line.dart';
class UserInfoRow extends StatelessWidget {
  final double rating;
  final int trips;
  final String profession;

  const UserInfoRow({
    Key? key,
    required this.rating,
    required this.trips,
    required this.profession,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(Icons.star, color: Colors.yellow, size: 15.sp),
        SizedBox(width: 2.w),
        Text('$rating', style: TextStyle(fontSize: 10.sp)),
        SizedBox(width: 5.w),
        CustomVerticalLine(height: 10.h, color: Colors.grey), // Your Custom Vertical Line
        SizedBox(width: 5.w),
        Text('$trips Trips', style: TextStyle(fontSize: 10.sp)),
        SizedBox(width: 5.w),
        CustomVerticalLine(height: 10.h, color: Colors.grey), // Your Custom Vertical Line
        SizedBox(width: 5.w),
        Image.asset('assets/images/steering-wheel.png', width: 15.w, height: 15.h),
        SizedBox(width: 5.w),
        Text(profession, style: TextStyle(fontSize: 10.sp, color: AppColors.togglebuttonColor)),
        SizedBox(width: 5.w),
      ],
    );
  }
}
