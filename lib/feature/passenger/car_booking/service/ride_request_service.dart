import 'package:ride_sharing/services/api_client.dart';
import 'package:ride_sharing/services/api_urls.dart';

class RideRequestService {
  final ApiClient _apiClient = ApiClient();

  Future<ApiResponse> calculateFare({
    required double distance,
    required String accessToken,
  }) async {
    return await _apiClient.getRequest(
      ApiUrls.calculateFare(distance),
      accessToken: accessToken,
    );
  }

  Future<ApiResponse> createRideRequest({
    required Map<String, dynamic> body,
    required String accessToken,
  }) async {
    return await _apiClient.postRequest(
      ApiUrls.createRideRequest,
      body: body,
      accessToken: accessToken,
    );
  }
}
