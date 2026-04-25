import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ride_sharing/app/theme/app_theme.dart';
import 'package:ride_sharing/l10n/app_localizations.dart';
import 'package:ride_sharing/routes/app_routes.dart';

class RideSharingApp extends StatelessWidget {
  const RideSharingApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool isBottomNavigationVisible(BuildContext context) {
      final EdgeInsets padding = MediaQuery.of(context).viewInsets;
      return padding.bottom == 0.0;
    }
    return ScreenUtilInit(
      splitScreenMode: true,
      minTextAdapt: true,
      designSize: Size(392, 852),
      builder: (_, _) {
        return GetMaterialApp(
          builder: (_, Widget? child) {
            final bool bottomNavigationVisible = isBottomNavigationVisible(context);
            return SafeArea(top: false, bottom: bottomNavigationVisible, child: child!);
          },
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: const Locale('fr'),
          supportedLocales: const [
            Locale('fr'), // French
            Locale('en'), // English
          ],
        //  darkTheme: AppThemeData.darkThemeData,
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.splashScreen, // Initial route
          getPages: AppRoutes.routes, // Your defined routes
          theme: AppThemeData.lightThemeData,
        );
      }
    );
  }
}
