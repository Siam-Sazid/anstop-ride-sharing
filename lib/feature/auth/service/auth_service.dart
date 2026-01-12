import 'package:ride_sharing/feature/auth/data/signup_request_model.dart';
import 'package:ride_sharing/feature/auth/data/signin_request_model.dart';
import 'package:ride_sharing/feature/auth/data/signin_response_model.dart';
import 'package:ride_sharing/feature/auth/data/verify_otp_request_model.dart';
import 'package:ride_sharing/services/api_client.dart';
import 'package:ride_sharing/services/api_urls.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  /// Sign up new user (RIDER or DRIVER)
  Future<ApiResponse> signUp(SignUpRequestModel signUpRequest) async {
    try {
      final response = await _apiClient.postRequest(
        ApiUrls.signUp,
        body: signUpRequest.toJson(),
      );
      return response;
    } catch (e) {
      return ApiResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  /// Sign in user
  Future<ApiResponse> signIn(SignInRequestModel signInRequest) async {
    try {
      final response = await _apiClient.postRequest(
        ApiUrls.signIn,
        body: signInRequest.toJson(),
      );
      return response;
    } catch (e) {
      return ApiResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  /// Verify OTP for email verification or password reset
  Future<ApiResponse> verifyOtp(VerifyOtpRequestModel verifyOtpRequest) async {
    try {
      final response = await _apiClient.postRequest(
        ApiUrls.verifyOtp,
        body: verifyOtpRequest.toJson(),
      );
      return response;
    } catch (e) {
      return ApiResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }
}
