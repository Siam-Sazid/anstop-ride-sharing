import 'package:ride_sharing/services/api_client.dart';
import 'package:ride_sharing/services/api_urls.dart';

class MyRideService {
  final ApiClient _apiClient = ApiClient();

  Future<ApiResponse> getMyRides({
    required String status,
    required String accessToken,
  }) async {
    return await _apiClient.getRequest(
      ApiUrls.myRides,
      accessToken: accessToken,
      queryParams: {
        'status': status,
      },
    );
  }
}
