import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class CustomBoxItems extends StatelessWidget {
  final String documentTitle;
  final bool isUploaded;
  final VoidCallback onTap;

  const CustomBoxItems({
    Key? key,
    required this.documentTitle,
    required this.isUploaded,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),

        ),
        child: Row(
         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Container(
              width: 100.w,
              height: 50.h,
              color: Color(0xFFE0E0E0),
            ),
           // SizedBox(width: 12.w),
            Expanded(
              child: Column(
                children: [
                  Text(
                    documentTitle,
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    isUploaded ? 'Uploaded' : 'Not Uploaded',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: isUploaded ? Colors.green : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward,
              size: 18.sp,
              color: Color(0xFF000000),
            ),
          ],
        ),
      ),
    );
  }
}
