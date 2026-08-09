import 'package:flutter/material.dart';

class CustomStatusCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final bool isLoading;

  const CustomStatusCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.fastOutSlowIn,
      constraints: const BoxConstraints(maxWidth: 480),
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.6), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ícone animado ou loader
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: isLoading
                ? SizedBox(
                    key: const ValueKey('loading'),
                    height: 64,
                    width: 64,
                    child: CircularProgressIndicator(
                      color: color,
                      strokeWidth: 4,
                    ),
                  )
                : Container(
                    key: const ValueKey('icon'),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 56, color: color),
                  ),
          ),
          const SizedBox(height: 24),

          // Título
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'Roboto',
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),

          // Subtítulo / Detalhes
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}