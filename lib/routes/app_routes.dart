import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
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
import 'package:ride_sharing/feature/car_booking/passenger/binding/pick_up_location_binding.dart';
import 'package:ride_sharing/feature/car_booking/passenger/set_on_map_screen.dart';
import 'package:ride_sharing/feature/homepage/passenger/binding/home_binding.dart';
import 'package:ride_sharing/feature/homepage/passenger/view/home_page.dart';
import 'package:ride_sharing/feature/payment/passenger/passenger_payment_screen.dart';
import 'package:ride_sharing/feature/set_location/binding/set_location_binding.dart';
import 'package:ride_sharing/feature/set_location/view/set_location_option_page.dart';
import 'package:ride_sharing/feature/set_location/view/set_location_screen.dart';
import 'package:ride_sharing/feature/splash_screen/splash_screen.dart';

import '../feature/car_booking/passenger/pick_up_location.dart';

abstract class AppRoutes {
  /// =========== > Initial Route < =========
  static const String initialRoutes = splashScreen;

  /// =========>Routes Name
  static const String splashScreen = '/';
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
  static const String homePage = '/home-page.dart';
  static const String passengerSetLocationOptionPage = '/passenger-location-option.dart';
  static const String passengersetLocationPage = '/passenger-location-page.dart';
  static const String passengerSetOnMapPage = '/set-on-map-page.dart';
  static const String passengerPickUpLocationPage = '/pick-up-location.dart';
  static const String passengerpaymentScreen = '/passenger-payment-screen.dart';
  static const String passengerCancelTaxiScreen = '/passenger-cancel-taxi.dart';


  ///============= > Routes < ============
  static final routes = [
    GetPage(
      name: splashScreen,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: logInScreen,
      page: () => LogInScreen(),
    ),
    GetPage(
      name: emailValidationScreen,
      page: () => EmailValidationScreen(),
    ),
    GetPage(
      name: otpVarificationScreen,
      page: () => OtpVarificationScreen(),
    ),
    GetPage(
      name: resetPasswordScreen,
      page: () => ResetPasswordScreen(),
    ),
    GetPage(
      name: passengerRegistrationScreen,
      page: () => PassengerRegistration(),
    ),
    GetPage(
      name: driverRegistrationScreen,
      page: () => DriverRegistration(),
    ),
    GetPage(
      name: uploadYourDocumentsScreen,
      page: () => UploadYourDocuments(),
    ),
    GetPage(
      name: nationalIdScreen,
      page: () => NationalIdScreen(),
    ),
    GetPage(
      name: drivingLicenseScreen,
      page: () => DrivingLicenseScreen(),
    ),
    GetPage(
      name: carInformationScreen,
      page: () => CarInformationScreen(),
    ),
    GetPage(
      name: uploadProfilePictureScreen,
      page: () => UploadProfilePictureScreen(),
    ),
    GetPage(
      name: homePage,
      page: () => HomePage(),
      binding: HomePageBinding(),
    ),

    GetPage(
      name: passengerSetLocationOptionPage,
      page: () => SetLocationOptionPage(),
    ),
    GetPage(
      name: passengersetLocationPage,
      page: () => SetLocationScreen(),
      binding: SetLocationBinding(),
    ), GetPage(
      name: passengerSetOnMapPage,
      page: () => SetOnMapScreen(),

    ),
    GetPage(
      name: passengerPickUpLocationPage,
      page: () => PickUpLocationScreen(),
      binding: PickUpLocationBinding(),



    ),GetPage(
      name: passengerpaymentScreen,
      page: () => PassengerPaymentScreen(),
    ),
    GetPage(
      name: passengerCancelTaxiScreen,
      page: () => SplashScreen(),
    ),
  ];
}
