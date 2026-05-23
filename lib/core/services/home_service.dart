import 'dart:convert';

import 'package:http/http.dart' as http;

class HomeService {
  static const String baseUrl = 'http://10.0.2.2:3000';

  static Future<Map<String, dynamic>> getHomeData(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/home/$userId'));

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200 && data['success'] != false) {
      return data;
    }

    throw Exception(data['message'] ?? 'Gagal mengambil data home');
  }
}
