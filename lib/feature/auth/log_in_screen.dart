import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ride_sharing/feature/auth/email_validation_screen.dart';
import 'package:ride_sharing/feature/auth/reset_password_screen.dart';
import 'package:ride_sharing/widgets/auth_links/auth_link.dart';
import '../../routes/app_routes.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    // Validate the form
    if (_formKey.currentState!.validate()) {
      // All fields are valid, proceed with login
      Get.toNamed(AppRoutes.passengerHomeScreen);
    } else {
      // Show error message
      Get.snackbar(
        'Validation Error',
        'Please fill in all required fields correctly',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 66.h),
                  LogoWidget(),
                  SizedBox(height: 52.h),
                  CustomTextField(
                    controller: _emailTEController,
                    hintText: AppString.emailHintText,
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
                    controller: _passwordTEController,
                    hintText: AppString.passwordHintText,
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
                      AppString.forgetPasswordTextButton,
                      style: TextStyle(
                          color: AppColors.errorColor,
                          fontSize: 12.sp,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.red,
                          decorationThickness: 2),
                    ),
                  ),
                  SizedBox(height: 13.h),
                  CustomButton(
                    onPressed: _handleLogin,
                    label: AppString.logInButtonText,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}