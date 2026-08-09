import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/healthcheck_model.dart';

class ApiService {
  // static const String baseUrl = 'http://127.0.0.1:8000'; // Servidor Local
  static const String baseUrl = 'https://luizdias01.pythonanywhere.com'; // Produção

  static Future<HealthcheckResponse> checkHealth() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/healthcheck/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // jsonDecode vem do 'dart:convert'
        final Map<String, dynamic> data = jsonDecode(response.body);
        return HealthcheckResponse.fromJson(data);
      } else {
        throw Exception('Servidor respondeu com código: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Falha na comunicação com a API: $e');
    }
  }
}