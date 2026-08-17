class LivroModel {
  final int? id;
  final String titulo;
  final String autor;
  final String isbn;
  final int anoPublicacao;
  final bool disponivel;
  final String? criadoEm;

  LivroModel({
    this.id,
    required this.titulo,
    required this.autor,
    required this.isbn,
    required this.anoPublicacao,
    this.disponivel = true,
    this.criadoEm,
  });

  factory LivroModel.fromJson(Map<String, dynamic> json) {
    return LivroModel(
      id: json['id'],
      titulo: json['titulo'] ?? '',
      autor: json['autor'] ?? '',
      isbn: json['isbn'] ?? '',
      anoPublicacao: json['ano_publicacao'] ?? DateTime.now().year,
      disponivel: json['disponivel'] ?? true,
      criadoEm: json['criado_em'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'autor': autor,
      'isbn': isbn,
      'ano_publicacao': anoPublicacao,
      'disponivel': disponivel,
    };
  }
}