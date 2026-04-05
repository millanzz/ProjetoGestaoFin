import 'package:flutter/material.dart';
import '../core/app_routes.dart';
import '../core/app_theme.dart';
import '../services/lancamento_service.dart';
import '../services/auth_service.dart';
import '../widgets/saldo_card.dart';
import '../widgets/resumo_card.dart';
import '../widgets/opcao_button.dart';
import '../widgets/grafico_pizza.dart';
import '../widgets/grafico_barras.dart';
import '../models/lancamento_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double saldo = LancamentoService.saldo;
    final double entradaMes = LancamentoService.totalReceitas;
    final double saidaMes = LancamentoService.totalDespesas;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.home, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        "Dashboard",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.perfil),
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: AppTheme.primaryBlue,
                      child: Text(
                        AuthService.iniciais,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),
              Text("Olá, ${AuthService.nome},", style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 20),

              SaldoCard(saldo: saldo),
              const SizedBox(height: 20),

              /// Entrada / Saída
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

              OpcaoButton(
                icon: Icons.add,
                texto: "Receita",
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.novaReceita),
              ),
              const SizedBox(height: 15),

              OpcaoButton(
                icon: Icons.remove,
                texto: "Despesa",
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.novaDespesa),
              ),
              const SizedBox(height: 15),

              OpcaoButton(
                icon: Icons.flag,
                texto: "Ver Metas",
                onTap: () => Navigator.pushNamed(context, AppRoutes.metas),
              ),

              const SizedBox(height: 30),

              /// Gráfico pizza — receitas vs despesas
              GraficoPizza(
                receitas: entradaMes,
                despesas: saidaMes,
              ),

              const SizedBox(height: 20),

              /// Gráfico barras — despesas por categoria
              GraficoBarras(
                titulo: "Despesas por categoria",
                lancamentos: LancamentoService.getDespesas(),
                corBarra: const Color(0xffe74c3c),
              ),

              const SizedBox(height: 20),

              /// Gráfico barras — receitas por categoria
              GraficoBarras(
                titulo: "Receitas por categoria",
                lancamentos: LancamentoService.getReceitas(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
