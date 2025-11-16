import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/utils/app_colors.dart';

class CustomTextFieldWithCheckbox extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool?> onCheckboxChanged;
  final String hintText;

  CustomTextFieldWithCheckbox({
    required this.isChecked,
    required this.onCheckboxChanged,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.sp),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grayShade100), // Border around the entire row
          borderRadius: BorderRadius.circular(10.r), // Rounded corners
        ),
        child: Row(
          children: [
            Checkbox(
              value: isChecked,
              onChanged: onCheckboxChanged,
              activeColor: AppColors.grayShade100,

            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none, // No border for the text field
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
