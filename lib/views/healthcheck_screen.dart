import 'package:flutter/material.dart';
import '../models/healthcheck_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../widgets/custom_status_card.dart';

class HealthcheckScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const HealthcheckScreen({super.key, required this.onLogout});

  @override
  State<HealthcheckScreen> createState() => _HealthcheckScreenState();
}

class _HealthcheckScreenState extends State<HealthcheckScreen> {
  late Future<HealthcheckResponse> _healthFuture;

  @override
  void initState() {
    super.initState();
    _healthFuture = ApiService.checkHealth();
  }

  void _atualizarStatus() {
    setState(() {
      _healthFuture = ApiService.checkHealth();
    });
  }

  Future<void> _efetuarLogout() async {
    await AuthService.logout();
    widget.onLogout();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = AuthService.currentUser?.user;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'BookFlow App',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: _atualizarStatus,
            tooltip: 'Recarregar Status',
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            onPressed: _efetuarLogout,
            tooltip: 'Sair do Sistema',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (user != null) ...[
                Chip(
                  avatar: const Icon(Icons.account_circle_rounded),
                  label: Text(
                    'Usuário: ${user.nomeExibicao} ${user.isBibliotecario ? "(Bibliotecário)" : ""}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  backgroundColor: Colors.white,
                ),
                const SizedBox(height: 24),
              ],
              const Text(
                'Status de Integração Back-end',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Sessão Autenticada via JWT',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),
              FutureBuilder<HealthcheckResponse>(
                future: _healthFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CustomStatusCard(
                      title: 'Conectando ao Servidor...',
                      subtitle: 'Validando credenciais com o servidor...',
                      color: Colors.orange,
                      icon: Icons.sync_rounded,
                      isLoading: true,
                    );
                  } else if (snapshot.hasError) {
                    return CustomStatusCard(
                      title: 'Falha na Conexão',
                      subtitle: snapshot.error.toString().replaceAll('Exception: ', ''),
                      color: Colors.redAccent,
                      icon: Icons.cloud_off_rounded,
                      isLoading: false,
                    );
                  } else if (snapshot.hasData) {
                    final data = snapshot.data!;
                    return CustomStatusCard(
                      title: 'API ${data.status.toUpperCase()}',
                      subtitle: '${data.mensagem}\n\n'
                          'Servidor: ${data.servidor}\n'
                          'Versão: ${data.versao}',
                      color: const Color(0xFF10B981),
                      icon: Icons.check_circle_rounded,
                      isLoading: false,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}