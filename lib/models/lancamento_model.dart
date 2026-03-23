enum TipoLancamento { receita, despesa }

class LancamentoModel {
  final String titulo;
  final double valor;
  final DateTime data;
  final TipoLancamento tipo;

  LancamentoModel({
    required this.titulo,
    required this.valor,
    required this.data,
    required this.tipo,
  });

  bool get isReceita => tipo == TipoLancamento.receita;
}