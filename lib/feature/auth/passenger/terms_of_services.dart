import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ride_sharing/l10n/l10n_helper.dart';

class TermsOfServices extends StatefulWidget {
  const TermsOfServices({super.key});

  @override
  State<TermsOfServices> createState() => _TermsOfServicesState();
}

class _TermsOfServicesState extends State<TermsOfServices> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.tr.termsOfServicesTitle),
        backgroundColor: Colors.white,
        forceMaterialTransparency: true,
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
          ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalization.tr.ourTermsOfServices,style: TextStyle(
              fontSize: 16.sp,
              color: Color(0XFF4E4E4E),
            ),),
            SizedBox(height: 8.h,),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Color(0XFF4E4E4E).withOpacity(0.01),
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(color: Color(0XFF4E4E4E).withOpacity(0.2)),
                ),
                child: Text(AppLocalization.tr.termsAndConditionText, style: TextStyle()),
              ),
            ),
            SizedBox(height: 33.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(
                  checkColor: Colors.white,
                  // fillColor: Color(0XFF323232),
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                ),
                Text(AppLocalization.tr.agreeWithTermsAndPrivacy,style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0XFF4E4E4E),
                ),)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
