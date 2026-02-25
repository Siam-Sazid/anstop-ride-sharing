import 'package:ride_sharing/services/api_client.dart';
import 'package:ride_sharing/services/api_urls.dart';

class DriverLocationService {
  final ApiClient _apiClient = ApiClient();

  Future<ApiResponse> updateCurrentLocation({
    required String accessToken,
    required String name,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _apiClient.postRequest(
        ApiUrls.currentLocation,
        body: {
          'name': name,
          'latitude': latitude,
          'longitude': longitude,
        },
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
