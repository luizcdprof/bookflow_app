import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/livro_model.dart';
import 'auth_service.dart';

class LivroService {
  static const String baseUrl = AuthService.baseUrl;

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (AuthService.isAuthenticated)
          'Authorization': 'Bearer ${AuthService.currentUser!.access}',
      };

  /// Lista livros com suporte opcional a busca (?search=...)
  static Future<List<LivroModel>> getLivros({String? search}) async {
    final uri = Uri.parse('$baseUrl/api/v1/livros/').replace(
      queryParameters: (search != null && search.isNotEmpty) ? {'search': search} : null,
    );

    final response = await http.get(uri, headers: _headers).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => LivroModel.fromJson(item)).toList();
    } else {
      throw Exception('Falha ao carregar livros (${response.statusCode})');
    }
  }

  /// Cadastra um novo livro (Requer perfil Bibliotecário)
  static Future<LivroModel> createLivro(LivroModel livro) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/livros/'),
      headers: _headers,
      body: jsonEncode(livro.toJson()),
    );

    if (response.statusCode == 201) {
      return LivroModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 403) {
      throw Exception('Apenas bibliotecários podem cadastrar livros.');
    } else {
      throw Exception('Erro ao cadastrar livro (${response.statusCode})');
    }
  }

  /// Atualiza um livro existente por ID
  static Future<LivroModel> updateLivro(int id, LivroModel livro) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/v1/livros/$id/'),
      headers: _headers,
      body: jsonEncode(livro.toJson()),
    );

    if (response.statusCode == 200) {
      return LivroModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao atualizar livro (${response.statusCode})');
    }
  }

  /// Remove um livro por ID
  static Future<void> deleteLivro(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/v1/livros/$id/'),
      headers: _headers,
    );

    if (response.statusCode != 204) {
      throw Exception('Erro ao excluir livro (${response.statusCode})');
    }
  }
}