import 'package:flutter/material.dart';
import 'views/healthcheck_screen.dart';

void main() {
  runApp(const BookFlowApp());
}

class BookFlowApp extends StatelessWidget {
  const BookFlowApp({super.key});

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
      home: const HealthcheckScreen(),
    );
  }
}