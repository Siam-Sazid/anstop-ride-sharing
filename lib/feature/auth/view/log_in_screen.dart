import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ride_sharing/custom_assets/app_image.dart';
import 'package:ride_sharing/feature/auth/view/email_validation_screen.dart';
import 'package:ride_sharing/feature/auth/view/reset_password_screen.dart';
import 'package:ride_sharing/feature/auth/controller/login_controller.dart';
import 'package:ride_sharing/widgets/auth_links/auth_link.dart';
import '../../../l10n/l10n_helper.dart';
import '../../../routes/app_routes.dart';

class LogInScreen extends StatelessWidget {
  LogInScreen({super.key});

  final LoginController _controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Form(
              key: _controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 66.h),
                  Image.asset(
                    AppImage.logoAnstop
                  ),
                  SizedBox(height: 52.h),
                  CustomTextField(
                    controller: _controller.emailTEController,
                    hintText: AppLocalization.tr.emailHintText,
                    hintextColor: Color(0XFF02243E),
                    hintextSize: 14.sp,
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: Color(0XFF191A44),
                    ),
                    isEmail: true,
                  ),
                  SizedBox(height: 16.h),
                  CustomTextField(
                    controller: _controller.passwordTEController,
                    hintText: AppLocalization.tr.passwordHintText,
                    hintextColor: Color(0XFF02243E),
                    hintextSize: 14.sp,
                    prefixIcon: Icon(Icons.key, color: Color(0XFF191A44)),
                    isPassword: true,
                    isObscureText: true,
                  ),
                  SizedBox(height: 10.h),
                  GestureDetector(
                    onTap: () {
                      Get.to(ResetPasswordScreen());
                    },
                    child: Text(
                      AppLocalization.tr.forgetPasswordTextButton,
                      style: TextStyle(
                          color: AppColors.errorColor,
                          fontSize: 12.sp,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.red,
                          decorationThickness: 2),
                    ),
                  ),
                  SizedBox(height: 13.h),
                  Obx(() => CustomButton(
                    onPressed: _controller.isLoading.value ? null : () {
                      _controller.login();
                    },
                    label: _controller.isLoading.value
                        ? 'Logging in...'
                        : AppLocalization.tr.logInButtonText,
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}