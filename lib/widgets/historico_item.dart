import 'package:flutter/material.dart';
import '../models/lancamento_model.dart';

class HistoricoItem extends StatelessWidget {
  final LancamentoModel lancamento;

  const HistoricoItem({super.key, required this.lancamento});

  @override
  Widget build(BuildContext context) {
    final isReceita = lancamento.isReceita;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [

          /// BOLINHA
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.blue.shade300,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 15),

          /// TÍTULO
          Expanded(
            child: Text(
              lancamento.titulo,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),

          /// VALOR
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