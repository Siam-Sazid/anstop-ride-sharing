import 'package:flutter/material.dart';
import 'package:ride_sharing/feature/auth/email_validation_screen.dart';
import 'package:ride_sharing/feature/auth/log_in_screen.dart';
import 'package:ride_sharing/feature/auth/otp_varification_screen.dart';
import 'package:ride_sharing/feature/auth/passenger/registration.dart';
import 'package:ride_sharing/feature/auth/reset_password_screen.dart';
import 'package:ride_sharing/feature/splash_screen/splash_screen.dart';

abstract class AppRoutes {
  /// =========== > Initial Route < =========
  static const String initialRoutes = splashScreen;

  /// =========>Routes Name
  static const String splashScreen = '/';

  /// ====> Authentication Related Route are here
  static const String logInScreen = '/log-in-screen.dart';
  static const String emailValidationScreen = '/email-validation-screen.dart';
  static const String otpVarificationScreen = '/otp-varification-screen.dart';
  static const String resetPasswordScreen = '/reset-password-screen.dart';
  static const String registrationScreen = '/registration-screen.dart';

  ///============= > Routes < ============
  static final routes = <String, WidgetBuilder>{
    splashScreen: (context) => SplashScreen(),
    logInScreen: (context) => LogInScreen(),
    emailValidationScreen: (context) => EmailValidationScreen(),
    otpVarificationScreen: (context) => OtpVarificationScreen(),
    resetPasswordScreen: (context) => ResetPasswordScreen(),
    registrationScreen: (context) => PassengerRegistration(),
  };
}
