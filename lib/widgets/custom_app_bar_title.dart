import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/passenger/passenger_custom_drawer.dart';
import 'logo.dart';

// Custom AppBar Page


// Custom AppBar Widget
class CustomAppBarTitle extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  final Size preferredSize;

  CustomAppBarTitle({required this.scaffoldKey})
      : preferredSize = Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.menu, color: Colors.black),
        onPressed: () {
          scaffoldKey.currentState?.openDrawer();
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0,top: 8),
          child: LogoWidget(
            width: 40.0,
            height: 40.0,
            fontSize: 15.sp,
          ),
        ),
      ],
    );
  }
}

