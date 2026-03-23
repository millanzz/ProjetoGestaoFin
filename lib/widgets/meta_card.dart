import 'package:flutter/material.dart';
import '../models/meta_model.dart';

class MetaCard extends StatelessWidget {
  final MetaModel meta;

  const MetaCard({super.key, required this.meta});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// TÍTULO + ÍCONE
          Row(
            children: [
              Text(
                meta.icone,
                style: const TextStyle(fontSize: 26),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  meta.titulo,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),

          const SizedBox(height: 10),

          /// VALORES
          Text(
            "R\$ ${meta.valorAtual.toStringAsFixed(2)} de R\$ ${meta.valorMeta.toStringAsFixed(2)}",
            style: const TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 15),

          /// BARRA DE PROGRESSO
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: meta.progresso,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation(
                Color(0xff6ea8fe),
              ),
            ),
          ),

          const SizedBox(height: 8),

          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "${meta.porcentagem}%",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff6ea8fe),
              ),
            ),
          ),
        ],
      ),
    );
  }
}