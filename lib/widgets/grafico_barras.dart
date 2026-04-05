import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../models/lancamento_model.dart';

/// Gráfico de barras que agrupa lançamentos por categoria.
/// Recebe a lista e calcula os totais internamente.
/// Quando o backend entrar, basta trocar a fonte da lista.
class GraficoBarras extends StatelessWidget {
  final String titulo;
  final List<LancamentoModel> lancamentos;
  final Color corBarra;

  const GraficoBarras({
    super.key,
    required this.titulo,
    required this.lancamentos,
    this.corBarra = AppTheme.primaryBlue,
  });

  /// Agrupa lançamentos por categoria e soma os valores
  Map<String, double> get _dadosPorCategoria {
    final mapa = <String, double>{};
    for (final l in lancamentos) {
      final cat = l.categoria ?? "Outros";
      mapa[cat] = (mapa[cat] ?? 0) + l.valor;
    }
    return mapa;
  }

  @override
  Widget build(BuildContext context) {
    final dados = _dadosPorCategoria;
    final categorias = dados.keys.toList();
    final valores = dados.values.toList();
    final maxValor = valores.isEmpty ? 100.0 : valores.reduce((a, b) => a > b ? a : b);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: categorias.isEmpty
                ? const Center(
                    child: Text(
                      "Sem dados ainda",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: maxValor * 1.2,
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          tooltipRoundedRadius: 8,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              "R\$ ${rod.toY.toStringAsFixed(2)}",
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 50,
                            getTitlesWidget: (value, meta) {
                              if (value == 0) return const SizedBox.shrink();
                              return Text(
                                _formatarValor(value),
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 36,
                            getTitlesWidget: (value, meta) {
                              final idx = value.toInt();
                              if (idx < 0 || idx >= categorias.length) {
                                return const SizedBox.shrink();
                              }
                              final label = categorias[idx].length > 6
                                  ? "${categorias[idx].substring(0, 6)}."
                                  : categorias[idx];
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  label,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: maxValor / 4,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: Colors.grey.shade200,
                          strokeWidth: 0.5,
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: List.generate(categorias.length, (i) {
                        return BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: valores[i],
                              color: corBarra,
                              width: categorias.length <= 3 ? 28 : 18,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(6),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  String _formatarValor(double valor) {
    if (valor >= 1000) {
      return "${(valor / 1000).toStringAsFixed(1)}k";
    }
    return valor.toStringAsFixed(0);
  }
}
