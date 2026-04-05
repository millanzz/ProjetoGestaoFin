import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class SaldoCard extends StatelessWidget {
  final double saldo;

  const SaldoCard({super.key, required this.saldo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: Text(
        "R\$ ${saldo.toStringAsFixed(2)}",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
