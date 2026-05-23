import 'dart:convert';

import 'package:http/http.dart' as http;

class FeatureClickService {
  const FeatureClickService._();

  static const String baseUrl = 'http://10.0.2.2:3000';

  static Future<void> trackFeatureClick({
    required String userId,
    required String featureName,
  }) async {
    try {
      await http.post(
        Uri.parse('$baseUrl/api/feature-click'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId, 'feature_name': featureName}),
      );
    } catch (_) {
      // Tracking failure should never interrupt the app flow.
    }
  }
}
