import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_model.dart';

class AuthService {
  // Alterne a URL base conforme o ambiente (Local ou Produção)
  // static const String baseUrl = 'http://127.0.0.1:8000';
  // static const String baseUrl = 'https://luizdias01.pythonanywhere.com';
  static const String baseUrl = 'https://bookflow-api-ygvo.onrender.com';

  // Guarda os dados da sessão em memória
  static AuthResponseModel? currentUser;

  static bool get isAuthenticated => currentUser != null;

  /// Efetua o login enviando username e password
  static Future<AuthResponseModel> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/auth/login/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final authData = AuthResponseModel.fromJson(data);
        currentUser = authData; // Salva o usuário logado na memória
        return authData;
      } else if (response.statusCode == 401) {
        throw Exception('Usuário ou senha inválidos.');
      } else {
        throw Exception('Falha ao autenticar: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Efetua o logout enviando o token de refresh para a Blacklist do Django
  static Future<void> logout() async {
    if (currentUser == null) return;

    try {
      await http.post(
        Uri.parse('$baseUrl/api/v1/auth/logout/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${currentUser!.access}',
        },
        body: jsonEncode({
          'refresh': currentUser!.refresh,
        }),
      );
    } catch (_) {
      // Mesmo se houver falha de rede, limpa a sessão localmente
    } finally {
      currentUser = null;
    }
  }
}