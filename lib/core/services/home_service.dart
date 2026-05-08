import 'dart:convert';

import 'package:http/http.dart' as http;

class HomeService {
  static const String baseUrl = 'http://10.0.2.2:3000';

  static Future<Map<String, dynamic>> getHomeData(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/home/$userId'),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      return data;
    }

    throw Exception('Gagal mengambil data home');
  }
}