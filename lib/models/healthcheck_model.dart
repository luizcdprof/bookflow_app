class HealthcheckResponse {
  final String status;
  final String mensagem;
  final String versao;
  final String servidor;

  HealthcheckResponse({
    required this.status,
    required this.mensagem,
    required this.versao,
    required this.servidor,
  });

  factory HealthcheckResponse.fromJson(Map<String, dynamic> json) {
    return HealthcheckResponse(
      status: json['status'] ?? 'desconhecido',
      mensagem: json['mensagem'] ?? 'Sem mensagem retornada',
      versao: json['versao'] ?? 'N/A',
      servidor: json['servidor'] ?? 'Django REST Framework',
    );
  }
}