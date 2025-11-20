import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/passenger/passenger_custom_drawer.dart';
import 'logo.dart';

// Custom AppBar Page


// Custom AppBar Widget
class CustomAppBarTitle extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String? title;
  final bool centerTitle;

  @override
  final Size preferredSize;

  const CustomAppBarTitle({
    required this.scaffoldKey,
    this.title,
    this.centerTitle = true,
    super.key,
  }) : preferredSize = const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: centerTitle,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.black),
        onPressed: () {
          scaffoldKey.currentState?.openDrawer();
        },
      ),
      title: title != null && title!.isNotEmpty
          ? Text(
        title!,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      )
          : null,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0, top: 8),
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

