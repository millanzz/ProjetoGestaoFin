import 'package:flutter/material.dart';
import '../widgets/lancamento_item.dart';
import '../widgets/grafico_financeiro.dart';
import 'nova_despesa_screen.dart';

class DespesaScreen extends StatelessWidget {
  const DespesaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),

      appBar: AppBar(
        title: const Text("Despesas"),
        backgroundColor: const Color(0xfff5f6fa),
        elevation: 0,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const NovaDespesaScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            /// LISTA
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListView(
                  children: const [

                    LancamentoItem(
                      titulo: "Mercado",
                      data: "05/05/2026",
                      valor: 120,
                      isEntrada: false,
                    ),

                    LancamentoItem(
                      titulo: "Internet",
                      data: "10/05/2026",
                      valor: 100,
                      isEntrada: false,
                    ),
                  ],
                ),
              ),
            ),

            /// GRÁFICO
            const GraficoFinanceiro(
              titulo: "Despesas do mês",
            ),
          ],
        ),
      ),
    );
  }
}