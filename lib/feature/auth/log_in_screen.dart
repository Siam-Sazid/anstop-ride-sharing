import 'package:ride_sharing/feature/auth/email_validation_screen.dart';
import 'package:ride_sharing/widgets/auth_links/auth_link.dart';
import '../../routes/app_routes.dart';

class LogInScreen extends StatelessWidget {
  LogInScreen({super.key});

  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                Text(
                  AppString.forgetPasswordTextButton,
                  style: TextStyle(
                    color: AppColors.errorColor,
                    fontSize: 12.sp,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.red,
                    decorationThickness: 2
                  ),
                ),
                SizedBox(height: 13.h),
                CustomButton(
                  onPressed: () {
                  //  Get.to(() => EmailValidationScreen());
                    Get.toNamed(AppRoutes.homePage);
                  },
                  label: AppString.logInButtonText,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
