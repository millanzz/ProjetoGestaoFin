import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../models/lancamento_model.dart';
import '../services/lancamento_service.dart';

class HistoricoScreen extends StatelessWidget {
  const HistoricoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lancamentos = LancamentoService.getAll();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text("Histórico"),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// Filtros
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Chip(label: Text("Este mês")),
                Chip(label: Text("5 meses")),
                Chip(label: Text("Personalizado")),
              ],
            ),

            const SizedBox(height: 20),

            /// Lista
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.cardBackground,
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: lancamentos.isEmpty
                    ? const Center(
                        child: Text(
                          "Nenhum lançamento",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: lancamentos.length,
                        itemBuilder: (context, index) {
                          return _HistoricoItem(
                            lancamento: lancamentos[index],
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget privado — usado somente nesta tela
class _HistoricoItem extends StatelessWidget {
  final LancamentoModel lancamento;

  const _HistoricoItem({required this.lancamento});

  @override
  Widget build(BuildContext context) {
    final isReceita = lancamento.isReceita;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.blue.shade300,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              lancamento.titulo,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Text(
            "${isReceita ? '' : '-'}R\$ ${lancamento.valor.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isReceita ? Colors.blue : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
