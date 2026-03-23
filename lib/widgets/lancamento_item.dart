import 'package:flutter/material.dart';

class LancamentoItem extends StatelessWidget {
  final String titulo;
  final String data;
  final double valor;
  final bool isEntrada;

  const LancamentoItem({
    super.key,
    required this.titulo,
    required this.data,
    required this.valor,
    required this.isEntrada,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color(0xffe8ecf5),
        child: Icon(
          isEntrada ? Icons.arrow_downward : Icons.arrow_upward,
          color: isEntrada ? Colors.green : Colors.red,
        ),
      ),
      title: Text(titulo),
      subtitle: Text(data),
      trailing: Text(
        "${isEntrada ? "+" : "-"} R\$ ${valor.toStringAsFixed(2)}",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isEntrada ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}