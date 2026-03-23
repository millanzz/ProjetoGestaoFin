import 'package:flutter/material.dart';

class SaldoCard extends StatelessWidget {
  final double saldo;

  const SaldoCard({
    super.key,
    required this.saldo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff6ea8fe), Color(0xff4e73df)],
        ),
        borderRadius: BorderRadius.circular(20),
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