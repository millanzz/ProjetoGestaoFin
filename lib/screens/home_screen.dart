import 'package:flutter/material.dart';

import '../widgets/saldo_card.dart';
import '../widgets/resumo_card.dart';
import '../widgets/opcao_button.dart';

import 'metas_screen.dart';
import 'perfil_screen.dart';

import 'nova_entrada_screen.dart';
import 'nova_despesa_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔵 Esses valores futuramente virão do backend
    final double saldo = 3800.00;
    final double entradaMes = 5000.00;
    final double saidaMes = 1200.00;

    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.home, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        "Dashboard",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),

                  /// FOTO PERFIL (BOTÃO)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PerfilScreen(),
                        ),
                      );
                    },
                    child: const CircleAvatar(
                      radius: 22,
                      backgroundImage: NetworkImage(
                        "https://i.pravatar.cc/300",
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              /// SAUDAÇÃO
              const Text(
                "Olá, Gustavo,",
                style: TextStyle(fontSize: 20),
              ),

              const SizedBox(height: 20),

              /// CARD SALDO (WIDGET SEPARADO)
              SaldoCard(saldo: saldo),

              const SizedBox(height: 20),

              /// ENTRADA / SAÍDA (WIDGETS SEPARADOS)
              Row(
                children: [
                  Expanded(
                    child: ResumoCard(
                      titulo: "Entrada no mês",
                      valor: entradaMes,
                      cor: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ResumoCard(
                      titulo: "Saída no mês",
                      valor: saidaMes,
                      cor: Colors.red,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              /// BOTÃO RECEITA
              OpcaoButton(
                icon: Icons.add,
                texto: "Receita",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NovaEntradaScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 15),

              /// BOTÃO DESPESA
              OpcaoButton(
                icon: Icons.remove,
                texto: "Despesa",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NovaDespesaScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 15),

              /// BOTÃO METAS
              OpcaoButton(
                icon: Icons.flag,
                texto: "Ver Metas",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MetasScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),

              /// CARD GRÁFICO (placeholder)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: const [
                    SizedBox(height: 10),
                    Icon(Icons.pie_chart, size: 80, color: Colors.blue),
                    SizedBox(height: 10),
                    Text(
                      "Receitas vs Despesas",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}