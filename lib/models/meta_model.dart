class MetaModel {
  final String id;
  final String titulo;
  final double valorAtual;
  final double valorMeta;
  final String icone;

  MetaModel({
    String? id,
    required this.titulo,
    required this.valorAtual,
    required this.valorMeta,
    required this.icone,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  double get progresso => valorAtual / valorMeta;

  int get porcentagem => (progresso * 100).toInt();

  Map<String, dynamic> toMap() => {
        'id': id,
        'titulo': titulo,
        'valorAtual': valorAtual,
        'valorMeta': valorMeta,
        'icone': icone,
      };

  factory MetaModel.fromMap(Map<String, dynamic> map) {
    return MetaModel(
      id: map['id'],
      titulo: map['titulo'],
      valorAtual: (map['valorAtual'] as num).toDouble(),
      valorMeta: (map['valorMeta'] as num).toDouble(),
      icone: map['icone'],
    );
  }
}
