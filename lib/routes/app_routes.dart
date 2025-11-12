import 'package:flutter/material.dart';
import 'package:ride_sharing/feature/auth/driver/car_information_screen.dart';
import 'package:ride_sharing/feature/auth/driver/driving_license_screen.dart';
import 'package:ride_sharing/feature/auth/driver/national_id_screen.dart';
import 'package:ride_sharing/feature/auth/driver/registration.dart';
import 'package:ride_sharing/feature/auth/driver/upload_profile_picture.dart';
import 'package:ride_sharing/feature/auth/driver/upload_your_documents_screen.dart';
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
  static const String passengerRegistrationScreen = '/passenger-registration-screen.dart';
  static const String driverRegistrationScreen = '/driver-registration-screen.dart';
  static const String uploadYourDocumentsScreen = '/upload-your-documents-screen.dart';
  static const String nationalIdScreen = '/national-id-screen.dart';
  static const String drivingLicenseScreen = '/driving-license-screen.dart';
  static const String carInformationScreen = '/car-information-screen.dart';
  static const String uploadProfilePictureScreen = '/upload-profile-picture-screen.dart';



  ///============= > Routes < ============
  static final routes = <String, WidgetBuilder>{
    splashScreen: (context) => SplashScreen(),
    logInScreen: (context) => LogInScreen(),
    emailValidationScreen: (context) => EmailValidationScreen(),
    otpVarificationScreen: (context) => OtpVarificationScreen(),
    resetPasswordScreen: (context) => ResetPasswordScreen(),
    passengerRegistrationScreen: (context) => PassengerRegistration(),
    driverRegistrationScreen: (context) => DriverRegistration(),
    uploadYourDocumentsScreen: (context) => UploadYourDocuments(),
    nationalIdScreen: (context) => NationalIdScreen(),
    drivingLicenseScreen: (context) => DrivingLicenseScreen(),
    carInformationScreen: (context) => CarInformationScreen(),
    uploadProfilePictureScreen: (context) => UploadProfilePictureScreen(),

  };
}
