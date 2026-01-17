import 'package:ride_sharing/services/api_client.dart';
import 'package:ride_sharing/services/api_urls.dart';

class DriverProfileService {
  final ApiClient _apiClient = ApiClient();

  Future<ApiResponse> getMyProfile({required String accessToken}) async {
    try {
      final response = await _apiClient.getRequest(
        ApiUrls.myProfile,
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

  Future<ApiResponse> updateProfile({
    required String accessToken,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await _apiClient.patchRequest(
        ApiUrls.updateProfile,
        body: body,
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
