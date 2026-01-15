import 'dart:io';
import 'package:ride_sharing/feature/auth/data/signup_request_model.dart';
import 'package:ride_sharing/feature/auth/data/signin_request_model.dart';
import 'package:ride_sharing/feature/auth/data/signin_response_model.dart';
import 'package:ride_sharing/feature/auth/data/verify_otp_request_model.dart';
import 'package:ride_sharing/feature/auth/data/forgot_password_request_model.dart';
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

  /// Forgot password - sends OTP to email for password reset
  Future<ApiResponse> forgotPassword(ForgotPasswordRequestModel request) async {
    try {
      final response = await _apiClient.postRequest(
        ApiUrls.forgotPassword,
        body: request.toJson(),
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

  /// Upload files and get URLs
  Future<ApiResponse> uploadFiles({
    required String accessToken,
    required List<File> files,
  }) async {
    try {
      // For single file upload, use 'files' as the field name
      // For multiple files, the backend should handle array
      final filesMap = <String, File>{
        'files': files[0], // Send first file with field name 'files'
      };

      final response = await _apiClient.postMultipartRequest(
        ApiUrls.uploadFiles,
        files: filesMap,
        accessToken: accessToken,
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

  /// Driver onboard - submit all driver documents and information
  Future<ApiResponse> driverOnboard({
    required String accessToken,
    required Map<String, dynamic> jsonBody,
  }) async {
    try {
      final response = await _apiClient.postRequest(
        ApiUrls.driverOnboard,
        body: jsonBody,
        accessToken: accessToken,
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

  /// Get driver onboarding status
  Future<ApiResponse> getDriverOnboardingStatus({
    required String accessToken,
  }) async {
    try {
      final response = await _apiClient.getRequest(
        ApiUrls.driverOnboardingStatus,
        accessToken: accessToken,
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
