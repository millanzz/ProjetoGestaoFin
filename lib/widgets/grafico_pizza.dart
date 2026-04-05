import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class GraficoPizza extends StatelessWidget {
  final double receitas;
  final double despesas;

  const GraficoPizza({
    super.key,
    required this.receitas,
    required this.despesas,
  });

  double get _total => receitas + despesas;

  @override
  Widget build(BuildContext context) {
    final semDados = _total == 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: Column(
        children: [
          const Text(
            "Receitas vs Despesas",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: semDados
                ? const Center(
                    child: Text(
                      "Sem dados ainda",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : PieChart(
                    PieChartData(
                      sectionsSpace: 3,
                      centerSpaceRadius: 40,
                      sections: _buildSections(),
                    ),
                  ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Legenda(cor: AppTheme.primaryBlue, texto: "Receitas"),
              const SizedBox(width: 24),
              _Legenda(cor: const Color(0xffe74c3c), texto: "Despesas"),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    final pctReceitas = receitas / _total * 100;
    final pctDespesas = despesas / _total * 100;

    return [
      PieChartSectionData(
        value: receitas,
        color: AppTheme.primaryBlue,
        radius: 50,
        title: "${pctReceitas.toStringAsFixed(0)}%",
        titleStyle: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
      PieChartSectionData(
        value: despesas,
        color: const Color(0xffe74c3c),
        radius: 50,
        title: "${pctDespesas.toStringAsFixed(0)}%",
        titleStyle: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    ];
  }
}

class _Legenda extends StatelessWidget {
  final Color cor;
  final String texto;

  const _Legenda({required this.cor, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(texto, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
