class ApiUrls {
  //static const String baseUrl = "http://217.15.170.117";
  static const String baseUrl = "https://abu-bakar7500.merinasib.shop/api/v1";


  ///Authentication///
 // static const String register = '$baseUrl/auth/register';
  static const String signUp = '$baseUrl/auth/sign-up';
  static const String signIn = '$baseUrl/auth/sign-in';
  static const String verifyOtp = '$baseUrl/auth/verify-otp';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String uploadFiles = '$baseUrl/users/upload-files';
  static const String driverOnboard = '$baseUrl/drivers/onboard';
  static const String driverOnboardingStatus = '$baseUrl/drivers/onboarding-status';


  //static const String imageBaseUrl = "http://217.15.170.117/";
  static const String imageBaseUrl = "https://mihad4000.merinasib.shop/";


  //static const String socketUrl = "http://217.15.170.117";
  static const String socketUrl = "https://abu-bakar7500.merinasib.shop";

  static const String myRides = '$baseUrl/rides/my-rides';

  static String getRideDetails(String rideId) => '$baseUrl/rides/$rideId';

  // Messages
  static String getMessages(String conversationId, {int page = 1, int limit = 50}) =>
      '$baseUrl/messages/$conversationId?page=$page&limit=$limit';

  // Settings
  static const String changePassword = '$baseUrl/auth/change-password';

  // Legal Documents
  static String getLegalDocument(String type) => '$baseUrl/legal-documents?type=$type';

  // Support
  static const String mySupportMessages = '$baseUrl/supports/my-messages';
  static const String createSupport = '$baseUrl/supports';

  // Profile
  static const String myProfile = '$baseUrl/users/my-profile';
  static const String updateProfile = '$baseUrl/users/profile';

  // Transactions
  static const String createTransactions = '$baseUrl/transactions';
  static const String getTransactions = '$baseUrl/transactions';
  static const String getBalance = '$baseUrl/users/balance';

  // Withdrawal
  static const String withdrawalRequests = '$baseUrl/withdrawal-requests';

  // Driver Location
  static const String currentLocation = '$baseUrl/users/current-location';

  // Ride Requests
  static String calculateFare(double distance) => '$baseUrl/rides/calculate-fare?distance=$distance';
  static const String createRideRequest = '$baseUrl/ride-requests/create-ride-request';
  static const String setFcmToken = '$baseUrl/users/fcm-token';


}
