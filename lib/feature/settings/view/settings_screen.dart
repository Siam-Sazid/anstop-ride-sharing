import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ride_sharing/feature/auth/passenger/terms_of_services.dart';
import 'package:ride_sharing/feature/settings/utils/settings_menu_item.dart';
import 'package:ride_sharing/feature/settings/view/change_password_screen.dart';
import 'package:ride_sharing/utils/driver/driver_custom_drawer.dart';
import 'package:ride_sharing/widgets/auth_links/auth_link.dart';
import '../../../app/utils/app_colors.dart';
import 'change_language_screen.dart';
import 'delete_account_dialog.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SettingsColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: SettingsColors.primaryText,
            size: 24,
          ),
          onPressed: () {},
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: SettingsColors.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: SettingsColors.primaryGreen,
              child: const Text(
                'Logo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: DriverCustomDrawer(),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(

                borderRadius: BorderRadius.circular(16),
                boxShadow: [

                ],
              ),
              child: Column(
                children: [
                  SettingsMenuItem(
                    icon: Icons.lock_outline,
                    title: 'Change Password',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePasswordScreen(),
                        ),
                      );
                    },
                  ),
                  SettingsMenuItem(
                    icon: Icons.info_outline,
                    title: 'About Us',
                    onTap: () {},
                  ),
                  SettingsMenuItem(
                    icon: Icons.shield_outlined,
                    title: 'Privacy Policy',
                    onTap: () {},
                  ),
                  SettingsMenuItem(
                    icon: Icons.description_outlined,
                    title: 'Terms of service',
                    onTap: () {
                      Get.to(() => TermsOfServices());
                    },
                  ),
                  SettingsMenuItem(
                    icon: Icons.language,
                    title: 'Change language',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangeLanguageScreen(),
                        ),
                      );
                    },
                    showDivider: false,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding:  EdgeInsets.fromLTRB(16.sp, 0, 16.sp, 32.sp),
            child: SizedBox(
              width: double.infinity,
              child: CustomButton(
                radius: 16.r,
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierColor: Colors.black.withOpacity(0.3),
                    builder: (context) => DeleteAccountDialog(
                      onDelete: () {
                        Navigator.pop(context);
                        // Handle delete account
                      },
                      onCancel: () {
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
                backgroundColor: SettingsColors.redButtonColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.delete_outline, size: 20,color: AppColors.white,),
                    SizedBox(width: 8),
                    Text(
                      'Delete Account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
