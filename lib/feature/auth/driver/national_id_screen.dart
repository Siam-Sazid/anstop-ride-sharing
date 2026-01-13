import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing/app/helpers/image_picker_helper.dart';
import 'package:ride_sharing/custom_assets/app_string.dart';
import 'package:ride_sharing/feature/auth/controller/national_id_controller.dart';
import 'package:ride_sharing/feature/auth/passenger/terms_of_services.dart';
import 'package:ride_sharing/widgets/auth_links/auth_link.dart';

class NationalIdScreen extends GetView<NationalIdController> {
  const NationalIdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 16.sp),
        child: CustomButton(
          onPressed: () {
            Get.back();
          },
          label: AppString.submitButton,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),
                Text(
                  AppString.nationalIdTitle,
                  style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 29.h),
                SizedBox(height: 12.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 4.sp),
                    child: Text(
                      AppString.nationalIdNumberLabel,
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
                CustomTextField(
                  controller: controller.nidNumberTEController,
                ),
                SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 4.sp),
                    child: Text(
                      AppString.uploadNationalIdFront,
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Obx(
                  () => GestureDetector(
                    onTap: () async {
                      final image = await ImagePickerHelper.pickImageWithOptions(context);
                      if (image != null) {
                        await controller.uploadAndSelectFrontImage(image);
                      }
                    },
                    child: CustomUploadItems(
                      borderWidth: 2.0,
                      borderColor: Colors.black,
                      uploadedImage: controller.frontImage.value,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 4.sp),
                    child: Text(
                      "Upload Driving License (back)",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Obx(
                  () => GestureDetector(
                    onTap: () async {
                      final image = await ImagePickerHelper.pickImageWithOptions(context);
                      if (image != null) {
                        await controller.uploadAndSelectBackImage(image);
                      }
                    },
                    child: CustomUploadItems(
                      borderWidth: 2.0,
                      borderColor: Colors.black,
                      uploadedImage: controller.backImage.value,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 55.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
