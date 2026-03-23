import 'package:flutter/material.dart';

class GraficoFinanceiro extends StatelessWidget {
  final String titulo;

  const GraficoFinanceiro({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            titulo,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          /// gráfico ilustrativo
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [

              _BarraGrafico(valor: 0.4),
              _BarraGrafico(valor: 0.7),
              _BarraGrafico(valor: 0.5),
              _BarraGrafico(valor: 0.8),
              _BarraGrafico(valor: 0.6),
            ],
          ),
        ],
      ),
    );
  }
}

class _BarraGrafico extends StatelessWidget {
  final double valor;

  const _BarraGrafico({required this.valor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 120 * valor,
      decoration: BoxDecoration(
        color: const Color(0xff4e73df),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}