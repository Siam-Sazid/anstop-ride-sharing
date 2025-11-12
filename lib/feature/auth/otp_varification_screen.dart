import 'package:ride_sharing/feature/auth/reset_password_screen.dart';
import 'package:ride_sharing/widgets/auth_links/auth_link.dart';

class OtpVarificationScreen extends StatelessWidget {
  const OtpVarificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppString.otpAppBarText),
        backgroundColor: AppColors.appBarColor,
        centerTitle: true,
        foregroundColor: Color(0XFF0A0A0A),
        forceMaterialTransparency: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 66.h),
              LogoWidget(),
              SizedBox(height: 52.h),
              CustomPinCodeTextField(),
              SizedBox(height: 12.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppString.otpDidNotGetText,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0XFF8A8A8A),
                      ),
                    ),
                    Text(
                      AppString.resendButtonText,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.red,
                        decorationThickness: 2.r,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 67.h),

              CustomButton(
                onPressed: () {
                  Get.to(() => ResetPasswordScreen());
                },
                label: AppString.otpVarificationButtonText,
              ),
              Spacer(),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
