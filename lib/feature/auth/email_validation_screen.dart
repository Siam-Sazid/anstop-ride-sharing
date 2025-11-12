import 'package:ride_sharing/feature/auth/otp_varification_screen.dart';
import 'package:ride_sharing/widgets/auth_links/auth_link.dart';

class EmailValidationScreen extends StatelessWidget {
  EmailValidationScreen({super.key});

  final TextEditingController _emailTEController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppString.emailValidationAppBarText),
        backgroundColor: AppColors.appBarColor,
        centerTitle: true,
        foregroundColor: Color(0XFF0A0A0A),
        forceMaterialTransparency: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
          ),
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
              Spacer(),

              CustomButton(
                onPressed: () {
                  Get.to(() => OtpVarificationScreen());
                },
                label: AppString.emailValidationButtonText,
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
