enum TipoLancamento { receita, despesa }

class LancamentoModel {
  final String id;
  final String titulo;
  final double valor;
  final DateTime data;
  final TipoLancamento tipo;
  final String? categoria;
  final bool parcelado;

  LancamentoModel({
    String? id,
    required this.titulo,
    required this.valor,
    required this.data,
    required this.tipo,
    this.categoria,
    this.parcelado = false,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  bool get isReceita => tipo == TipoLancamento.receita;

  /// Futuramente: factory fromJson / toJson para integração com backend
  Map<String, dynamic> toMap() => {
        'id': id,
        'titulo': titulo,
        'valor': valor,
        'data': data.toIso8601String(),
        'tipo': tipo.name,
        'categoria': categoria,
        'parcelado': parcelado,
      };

  factory LancamentoModel.fromMap(Map<String, dynamic> map) {
    return LancamentoModel(
      id: map['id'],
      titulo: map['titulo'],
      valor: (map['valor'] as num).toDouble(),
      data: DateTime.parse(map['data']),
      tipo: TipoLancamento.values.byName(map['tipo']),
      categoria: map['categoria'],
      parcelado: map['parcelado'] ?? false,
    );
  }
}
