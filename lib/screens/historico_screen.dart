import 'package:flutter/material.dart';
import '../models/lancamento_model.dart';
import '../widgets/historico_item.dart';

class HistoricoScreen extends StatelessWidget {
  const HistoricoScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final lancamentos = [
      LancamentoModel(
        titulo: "Salário",
        valor: 2000,
        data: DateTime.now(),
        tipo: TipoLancamento.receita,
      ),
      LancamentoModel(
        titulo: "Mercado",
        valor: 60,
        data: DateTime.now(),
        tipo: TipoLancamento.despesa,
      ),
      LancamentoModel(
        titulo: "Transporte",
        valor: 25,
        data: DateTime.now(),
        tipo: TipoLancamento.despesa,
      ),
      LancamentoModel(
        titulo: "Investimento",
        valor: 400,
        data: DateTime.now(),
        tipo: TipoLancamento.despesa,
      ),
      LancamentoModel(
        titulo: "Internet",
        valor: 100,
        data: DateTime.now(),
        tipo: TipoLancamento.despesa,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),

      appBar: AppBar(
        title: const Text("Histórico"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            /// FILTRO
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Chip(label: Text("Este mês")),
                Chip(label: Text("5 meses")),
                Chip(label: Text("Personalizado")),
              ],
            ),

            const SizedBox(height: 20),

            /// CARD
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ListView.builder(
                  itemCount: lancamentos.length,
                  itemBuilder: (context, index) {
                    return HistoricoItem(
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