import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_sharing/l10n/l10n_helper.dart';
import '../../../app/utils/app_colors.dart';
import '../../../widgets/custom_text_field.dart';


class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: SettingsColors.primaryText,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          L10n.tr.changePasswordOption,
          style: const TextStyle(
            color: SettingsColors.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(L10n.tr.currentPasswordLabel),
                  CustomTextField(
                    isObscureText: true,
                    isPassword: true,
                    controller: _currentPasswordController,
                    prefixIcon: Icon(
                      Icons.key,
                      color: Color(0XFF8A8A8A),
                      size: 24.sp,
                    ),
                    hintText: L10n.tr.enterOldPasswordHint,
                    hintextSize: 14.sp,
                    hintextColor: Color(0XFF8A8A8A),
                  ),
                  SizedBox(height: 12.h),
                  Text(L10n.tr.newPasswordLabel),
                  CustomTextField(
                    isObscureText: true,
                    isPassword: true,
                    controller: _newPasswordController,
                    prefixIcon: Icon(
                      Icons.key,
                      color: Color(0XFF8A8A8A),
                      size: 24.sp,
                    ),
                    hintText: L10n.tr.enterNewPasswordHint,
                    hintextSize: 14.sp,
                    hintextColor: Color(0XFF8A8A8A),
                  ),
                  SizedBox(height: 12.h),
                  Text(L10n.tr.passwordLabel),
                  CustomTextField(
                    isObscureText: true,
                    isPassword: true,
                    controller: _confirmPasswordController,
                    prefixIcon: Icon(
                      Icons.key,
                      color: Color(0XFF8A8A8A),
                      size: 24.sp,
                    ),
                    hintText: L10n.tr.reenterPasswordHint,
                    hintextSize: 14.sp,
                    hintextColor: Color(0XFF8A8A8A),
                  ),

                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Handle forgot password
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: SettingsColors.primaryText,
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        L10n.tr.forgetPasswordTextButton,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle password update
                  _showSuccessDialog();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: SettingsColors.primaryGreen,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  L10n.tr.resetPasswordConfirmButton,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: SettingsColors.primaryGreen,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                L10n.tr.resetPasswordAppBarText,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: SettingsColors.primaryText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                L10n.tr.reportSubmittedMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: SettingsColors.secondaryText,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SettingsColors.primaryGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    L10n.tr.okButton,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
