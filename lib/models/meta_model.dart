class MetaModel {
  final String titulo;
  final double valorAtual;
  final double valorMeta;
  final String icone;

  MetaModel({
    required this.titulo,
    required this.valorAtual,
    required this.valorMeta,
    required this.icone,
  });

  double get progresso => valorAtual / valorMeta;

  int get porcentagem => (progresso * 100).toInt();
}