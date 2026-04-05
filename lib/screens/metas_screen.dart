import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../models/meta_model.dart';
import '../widgets/meta_card.dart';

class MetasScreen extends StatelessWidget {
  const MetasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Futuramente: virá do MetaService
    final metas = [
      MetaModel(
        titulo: "Comprar notebook",
        valorAtual: 900,
        valorMeta: 2000,
        icone: "\u{1F4BB}",
      ),
      MetaModel(
        titulo: "Viagem",
        valorAtual: 5600,
        valorMeta: 8000,
        icone: "\u{1F3DD}",
      ),
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                "Metas",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25),
              Expanded(
                child: ListView.builder(
                  itemCount: metas.length,
                  itemBuilder: (context, index) => MetaCard(meta: metas[index]),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        elevation: 5,
        onPressed: () {},
        icon: const Icon(Icons.add, color: AppTheme.lightBlue),
        label: const Text(
          "Nova Meta",
          style: TextStyle(color: AppTheme.lightBlue),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
