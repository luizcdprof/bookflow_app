import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/healthcheck_model.dart';
import 'auth_service.dart';

class ApiService {
  // Centraliza a URL pegando direto do AuthService
  static const String baseUrl = AuthService.baseUrl;

  static Future<HealthcheckResponse> checkHealth() async {
    try {
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      // Se o usuário estiver logado, injeta o token JWT no cabeçalho Bearer
      if (AuthService.isAuthenticated) {
        headers['Authorization'] = 'Bearer ${AuthService.currentUser!.access}';
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/healthcheck/'),
        headers: headers,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
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