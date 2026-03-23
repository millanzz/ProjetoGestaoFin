import 'package:flutter/material.dart';
import '../widgets/lancamento_form.dart';

class NovaDespesaScreen extends StatelessWidget {
  const NovaDespesaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LancamentoForm(
      titulo: "Registrar Despesa",
      textoBotao: "Salvar Despesa",
      isReceita: false,
      categorias: const [
        "Alimentação",
        "Transporte",
        "Moradia",
        "Saúde",
        "Lazer",
        "Compras",
        "Assinaturas",
        "Impostos",
        "Outros"
      ],
    );
  }
}