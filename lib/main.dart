import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'views/livros_screen.dart';
import 'views/login_screen.dart';

void main() {
  runApp(const BookFlowApp());
}

class BookFlowApp extends StatefulWidget {
  const BookFlowApp({super.key});

  @override
  State<BookFlowApp> createState() => _BookFlowAppState();
}

class _BookFlowAppState extends State<BookFlowApp> {
  void _atualizarEstadoNavegacao() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookFlow App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.light,
        ),
      ),
      // Mapeamento de rotas para fácil navegação
      routes: {
        '/login': (context) => LoginScreen(onLoginSuccess: _atualizarEstadoNavegacao),
        '/livros': (context) => const LivrosScreen(),
      },
      // Exibe LivrosScreen se estiver logado, ou LoginScreen se não estiver
      home: AuthService.isAuthenticated
          ? const LivrosScreen()
          : LoginScreen(onLoginSuccess: _atualizarEstadoNavegacao),
    );
  }
}