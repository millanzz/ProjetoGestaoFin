import 'package:flutter/material.dart';
import '../widgets/lancamento_form.dart';

class NovaEntradaScreen extends StatelessWidget {
  const NovaEntradaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LancamentoForm(
      titulo: "Registrar Receita",
      textoBotao: "Salvar Receita",
      isReceita: true,
      categorias: const [
        "Salário",
        "Freelance",
        "Investimentos",
        "Bônus",
        "Outros"
      ],
    );
  }
}