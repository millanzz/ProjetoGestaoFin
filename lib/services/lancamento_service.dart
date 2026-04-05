import '../models/lancamento_model.dart';

/// Serviço responsável por CRUD de lançamentos.
/// Hoje usa lista local. Futuramente: HTTP/Firebase/SQLite.
class LancamentoService {
  // Dados temporários em memória (substituir por backend)
  static final List<LancamentoModel> _lancamentos = [
    LancamentoModel(
      titulo: "Salário",
      valor: 3000,
      data: DateTime.now(),
      tipo: TipoLancamento.receita,
      categoria: "Salário",
    ),
    LancamentoModel(
      titulo: "Freelance",
      valor: 800,
      data: DateTime.now(),
      tipo: TipoLancamento.receita,
      categoria: "Freelance",
    ),
    LancamentoModel(
      titulo: "Mercado",
      valor: 120,
      data: DateTime.now(),
      tipo: TipoLancamento.despesa,
      categoria: "Alimentação",
    ),
    LancamentoModel(
      titulo: "Internet",
      valor: 100,
      data: DateTime.now(),
      tipo: TipoLancamento.despesa,
      categoria: "Assinaturas",
    ),
    LancamentoModel(
      titulo: "Transporte",
      valor: 25,
      data: DateTime.now(),
      tipo: TipoLancamento.despesa,
      categoria: "Transporte",
    ),
  ];

  static List<LancamentoModel> getAll() => List.unmodifiable(_lancamentos);

  static List<LancamentoModel> getReceitas() =>
      _lancamentos.where((l) => l.isReceita).toList();

  static List<LancamentoModel> getDespesas() =>
      _lancamentos.where((l) => !l.isReceita).toList();

  static double get totalReceitas =>
      getReceitas().fold(0, (sum, l) => sum + l.valor);

  static double get totalDespesas =>
      getDespesas().fold(0, (sum, l) => sum + l.valor);

  static double get saldo => totalReceitas - totalDespesas;

  static void adicionar(LancamentoModel lancamento) {
    _lancamentos.add(lancamento);
  }

  static void remover(String id) {
    _lancamentos.removeWhere((l) => l.id == id);
  }
}
