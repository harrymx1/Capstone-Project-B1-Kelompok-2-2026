import 'dart:convert';

import 'package:http/http.dart' as http;

class FeatureTrackingService {
  const FeatureTrackingService._();

  static const String baseUrl = 'http://10.0.2.2:3000';

  static Future<void> trackFeatureClick({
    required String userId,
    required String featureName,
  }) async {
    try {
      await http.post(
        Uri.parse('$baseUrl/api/log'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'action': 'FEATURE_CLICK',
          'reason': 'User clicked $featureName from home',
        }),
      );
    } catch (_) {
      // Tracking must never interrupt the user's navigation flow.
    }
  }
}
