import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_drawer.dart';
import 'logo.dart';

// Custom AppBar Page


// Custom AppBar Widget
class CustomAppBarTitle extends StatelessWidget implements PreferredSizeWidget { // Implement PreferredSizeWidget
  @override
  final Size preferredSize; // Implement preferredSize

  CustomAppBarTitle({Key? key})
      : preferredSize = Size.fromHeight(80), // Set the height of the AppBar
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white, // White color for the AppBar
      elevation: 0, // Remove the shadow
      leading: IconButton(
        icon: Icon(Icons.menu, color: Colors.black), // Menu icon
        onPressed: () {
          Scaffold.of(context).openDrawer(); // Open the drawer when tapped
        },
      ),

      actions: [
        // Custom Logo Widget at the right end of the AppBar
        Padding(
          padding: const EdgeInsets.only(right: 16.0), // Add some padding for spacing
          child: LogoWidget(
            width: 40.0, // You can customize the width and height of the logo
            height: 40.0,
            fontSize: 15.sp,
          ),
        ),
      ],

    );
  }
}
