import 'dart:convert';

import 'package:http/http.dart' as http;

class ConsentService {
  const ConsentService._();

  static const String baseUrl = 'http://10.0.2.2:3000';

  static Future<void> updateConsent({
    required String userId,
    required bool consentStatus,
  }) async {

    final response = await http.post(
      Uri.parse('$baseUrl/api/consent'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'consent_status': consentStatus ? 1 : 0,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception(data['message'] ?? 'Gagal memperbarui pengaturan');
    }
  }
}
