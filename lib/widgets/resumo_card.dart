import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class ResumoCard extends StatelessWidget {
  final String titulo;
  final double valor;
  final Color cor;

  const ResumoCard({
    super.key,
    required this.titulo,
    required this.valor,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo),
          const SizedBox(height: 8),
          Text(
            "R\$ ${valor.toStringAsFixed(2)}",
            style: TextStyle(
              color: cor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
