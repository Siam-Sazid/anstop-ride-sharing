import 'package:ride_sharing/feature/auth/view/otp_varification_screen.dart';
import 'package:ride_sharing/l10n/l10n_helper.dart';
import 'package:ride_sharing/widgets/auth_links/auth_link.dart';
import 'package:ride_sharing/routes/app_routes.dart';

class EmailValidationScreen extends StatefulWidget {
  EmailValidationScreen({super.key});

  @override
  State<EmailValidationScreen> createState() => _EmailValidationScreenState();
}

class _EmailValidationScreenState extends State<EmailValidationScreen> {
  final TextEditingController _emailTEController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Get email from arguments if available
    final email = Get.arguments?['email'];
    if (email != null) {
      _emailTEController.text = email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.tr.emailValidationAppBarText),
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
                hintText: AppLocalization.tr.emailHintText,
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
                  Get.toNamed(
                    AppRoutes.otpVerificationScreen,
                    arguments: {'email': _emailTEController.text.trim()},
                  );
                },
                label: AppLocalization.tr.emailValidationButtonText,
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
