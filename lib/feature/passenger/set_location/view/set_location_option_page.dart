// set_location_option_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_sharing/app/utils/app_colors.dart';
import 'package:get/get.dart';
import 'package:ride_sharing/routes/app_routes.dart';

import '../../../../l10n/l10n_helper.dart';

class SetLocationOptionPage extends StatelessWidget {
  const SetLocationOptionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryBgColor,
      appBar: AppBar(
        title: Text(L10n.tr.setYourLocationTitle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
       centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Search bar
          TextField(
            onTap: (){
              Get.toNamed(AppRoutes.setLocationScreen);
            },
            decoration: InputDecoration(
              hintText: L10n.tr.searchAddressHint,
              prefixIcon: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.sp,vertical: 2.sp),
                decoration: BoxDecoration(
                  color: AppColors.secondaryBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.bookmark, color: AppColors.iconColor),
              ),
              suffixIcon: Icon(Icons.search,color: AppColors.iconColor,),
              border: InputBorder.none,
              filled: true,
              fillColor: AppColors.white,
            ),
          ),

          SizedBox(height: 10.sp),
          // Location options
          Expanded(
            child: ListView(
              children: [
                SetLocationOptionCard(
                  icon: Icons.pin_drop_rounded,
                  title: L10n.tr.setOnMapOption,
                  onTap: () {
                    Get.toNamed(AppRoutes.setLocationScreen);
                    print('Home tapped');
                  },
                ),
                SetLocationOptionCard(
                  icon: Icons.home,
                  title: L10n.tr.homeOption,
                  onTap: () {
                    Get.toNamed(AppRoutes.setLocationScreen);
                    print('Home tapped');
                  },
                ),
                SetLocationOptionCard(
                  icon: Icons.work,
                  title: L10n.tr.workOption,
                  onTap: () {
                    Get.toNamed(AppRoutes.setLocationScreen);
                    print('Work tapped');
                  },
                ),
                SetLocationOptionCard(
                  icon: Icons.bookmark,
                  title: L10n.tr.bookmarksOption,
                  onTap: () {
                    Get.toNamed(AppRoutes.setLocationScreen);
                    print('Bookmarks tapped');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class SetLocationOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const SetLocationOptionCard({
    required this.icon,
    required this.title,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.only(bottom: 10.sp, left: 0, right: 0),
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.all(8), // Adjust the padding for the icon
            decoration: BoxDecoration(
              color: AppColors.secondaryBgColor, // Background color for the circle
              shape: BoxShape.circle, // Makes the container circular
            ),
            child: Icon(icon, color: AppColors.iconColor), // Icon inside the circle
          ),
          title: Text(title),
          subtitle: Text(L10n.tr.setAddressSubtitle),
          onTap: onTap,
        ),
      ),
    );
  }

}
