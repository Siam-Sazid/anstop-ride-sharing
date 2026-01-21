import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ride_sharing/services/api_urls.dart';
import 'package:logger/logger.dart';

class FcmService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final Logger _logger = Logger(); // ✅ Logger instance

  Future<void> initFCM({required String accessToken}) async {
    // 🔔 Request permission
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 🔑 Get FCM token
    final token = await _messaging.getToken();

    if (token != null) {
      _logger.i('🟢 Generated FCM Token: $token'); // log generated token
      await _sendFcmTokenToApi(
        fcmToken: token,
        accessToken: accessToken,
      );
    }

    // 🔄 Handle token refresh
    _messaging.onTokenRefresh.listen((newToken) async {
      _logger.i('♻️ FCM Token refreshed: $newToken'); // log refreshed token
      await _sendFcmTokenToApi(
        fcmToken: newToken,
        accessToken: accessToken,
      );
    });
  }

  Future<void> _sendFcmTokenToApi({
    required String fcmToken,
    required String accessToken,
  }) async {
    try {
      _logger.i('➡️ Sending FCM token to API: $fcmToken'); // log token being sent

      final response = await http.post(
        Uri.parse(ApiUrls.setFcmToken),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'fcmToken': fcmToken,
        }),
      );

      if (response.statusCode == 200) {
        _logger.i('✅ FCM token sent successfully to API');
      } else {
        _logger.w('❌ Failed to send FCM token: ${response.body}');
      }
    } catch (e) {
      _logger.e('❌ FCM API ERROR: $e');
    }
  }
}
