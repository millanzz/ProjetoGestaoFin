import 'package:flutter/material.dart';
import '../widgets/lancamento_item.dart';
import '../widgets/grafico_financeiro.dart';
import 'nova_entrada_screen.dart';

class EntradaScreen extends StatelessWidget {
  const EntradaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),

      appBar: AppBar(
        title: const Text("Entradas"),
        backgroundColor: const Color(0xfff5f6fa),
        elevation: 0,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const NovaEntradaScreen(),
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
                      titulo: "Salário",
                      data: "05/05/2026",
                      valor: 3000,
                      isEntrada: true,
                    ),

                    LancamentoItem(
                      titulo: "Freelance",
                      data: "10/05/2026",
                      valor: 800,
                      isEntrada: true,
                    ),
                  ],
                ),
              ),
            ),

            /// GRÁFICO
            const GraficoFinanceiro(
              titulo: "Entradas do mês",
            ),
          ],
        ),
      ),
    );
  }
}