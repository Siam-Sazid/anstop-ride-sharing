import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ride_sharing/app/theme/app_theme.dart';
import 'package:ride_sharing/routes/app_routes.dart';

class RideSharingApp extends StatelessWidget {
  const RideSharingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      splitScreenMode: true,
      minTextAdapt: true,
      designSize: Size(392, 852),
      builder: (_, _) => GetMaterialApp(
        darkTheme: AppThemeData.darkThemeData,
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.splashScreen,
        routes: AppRoutes.routes,
        theme: AppThemeData.lightThemeData,
        // routes: AppRoutes.registrationScreen,
        // builder: (context, child) =>
        //     Scaffold(body: NoInternetWrapper(child: child!)),
      ),
    );
  }
}
