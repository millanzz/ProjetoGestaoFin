import 'package:flutter/material.dart';
import '../core/app_routes.dart';
import '../core/app_theme.dart';
import '../models/lancamento_model.dart';
import '../services/lancamento_service.dart';
import '../widgets/grafico_barras.dart';

class LancamentosScreen extends StatelessWidget {
  final TipoLancamento tipo;

  const LancamentosScreen({super.key, required this.tipo});

  bool get _isReceita => tipo == TipoLancamento.receita;

  String get _titulo => _isReceita ? "Entradas" : "Despesas";

  String get _grafTitulo =>
      _isReceita ? "Entradas do mês" : "Despesas do mês";

  List<LancamentoModel> get _lancamentos =>
      _isReceita ? LancamentoService.getReceitas() : LancamentoService.getDespesas();

  @override
  Widget build(BuildContext context) {
    final lancamentos = _lancamentos;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text(_titulo)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            _isReceita ? AppRoutes.novaReceita : AppRoutes.novaDespesa,
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// Lista de lançamentos
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.cardBackground,
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                ),
                child: lancamentos.isEmpty
                    ? const Center(
                        child: Text(
                          "Nenhum lançamento ainda",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: lancamentos.length,
                        itemBuilder: (context, index) {
                          return _LancamentoItem(lancamento: lancamentos[index]);
                        },
                      ),
              ),
            ),

            /// Gráfico de barras com dados reais
            GraficoBarras(
              titulo: _grafTitulo,
              lancamentos: lancamentos,
              corBarra: _isReceita
                  ? AppTheme.primaryBlue
                  : const Color(0xffe74c3c),
            ),
          ],
        ),
      ),
    );
  }
}

/// --- Widgets privados (usados só nesta tela) ---

class _LancamentoItem extends StatelessWidget {
  final LancamentoModel lancamento;

  const _LancamentoItem({required this.lancamento});

  @override
  Widget build(BuildContext context) {
    final isReceita = lancamento.isReceita;
    final dataFormatada =
        "${lancamento.data.day.toString().padLeft(2, '0')}/"
        "${lancamento.data.month.toString().padLeft(2, '0')}/"
        "${lancamento.data.year}";

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color(0xffe8ecf5),
        child: Icon(
          isReceita ? Icons.arrow_downward : Icons.arrow_upward,
          color: isReceita ? Colors.green : Colors.red,
        ),
      ),
      title: Text(lancamento.titulo),
      subtitle: Text(dataFormatada),
      trailing: Text(
        "${isReceita ? "+" : "-"} R\$ ${lancamento.valor.toStringAsFixed(2)}",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isReceita ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}


