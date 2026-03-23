import 'package:flutter/material.dart';
import '../models/meta_model.dart';
import '../widgets/meta_card.dart';

class MetasScreen extends StatelessWidget {
  const MetasScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final metas = [
      MetaModel(
        titulo: "Comprar notebook",
        valorAtual: 900,
        valorMeta: 2000,
        icone: "💻",
      ),
      MetaModel(
        titulo: "Viagem",
        valorAtual: 5600,
        valorMeta: 8000,
        icone: "🏝️",
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 10),

              /// TÍTULO
              const Text(
                "Metas",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              /// LISTA DE METAS
              Expanded(
                child: ListView.builder(
                  itemCount: metas.length,
                  itemBuilder: (context, index) {
                    return MetaCard(meta: metas[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      /// BOTÃO NOVA META
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        elevation: 5,
        onPressed: () {},
        icon: const Icon(Icons.add, color: Color(0xff6ea8fe)),
        label: const Text(
          "Nova Meta",
          style: TextStyle(color: Color(0xff6ea8fe)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}