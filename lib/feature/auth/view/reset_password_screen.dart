import 'package:ride_sharing/l10n/l10n_helper.dart';
import 'package:ride_sharing/widgets/auth_links/auth_link.dart';

import '../../../custom_assets/app_image.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.tr.resetPasswordAppBarText),
        backgroundColor: AppColors.appBarColor,
        centerTitle: true,
        foregroundColor: Color(0XFF0A0A0A),
        forceMaterialTransparency: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: 66.h),
                Image.asset(
                    AppImage.logoAnstop
                ),
                SizedBox(height: 52.h),
                CustomTextField(
                  controller: _passwordTEController,
                  hintText: AppLocalization.tr.resetPasswordHintText,
                  hintextColor: Color(0XFF02243E),
                  hintextSize: 14.sp,
                  prefixIcon: Icon(Icons.key, color: Color(0XFF191A44)),
                  isPassword: true,
                  isObscureText: true,
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  controller: _confirmPasswordTEController,
                  hintText: AppLocalization.tr.resetConfirmPasswordHintText,
                  hintextColor: Color(0XFF02243E),
                  hintextSize: 14.sp,
                  prefixIcon: Icon(Icons.key, color: Color(0XFF191A44)),
                  isPassword: true,
                  isObscureText: true,
                ),

                SizedBox(height: 32.h),
                CustomButton(
                  onPressed: () {},
                  label: AppLocalization.tr.resetPasswordConfirmButton,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
