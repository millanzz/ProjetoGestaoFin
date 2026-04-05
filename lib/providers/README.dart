/// Placeholder para gerenciamento de estado.
///
/// Quando integrar o backend, use ChangeNotifier + Provider:
///
/// ```dart
/// class LancamentoProvider extends ChangeNotifier {
///   List<LancamentoModel> _lancamentos = [];
///   bool _loading = false;
///
///   List<LancamentoModel> get lancamentos => _lancamentos;
///   bool get loading => _loading;
///
///   Future<void> carregar() async {
///     _loading = true;
///     notifyListeners();
///
///     _lancamentos = await LancamentoService.fetchAll();
///     _loading = false;
///     notifyListeners();
///   }
///
///   Future<void> adicionar(LancamentoModel l) async {
///     await LancamentoService.create(l);
///     await carregar();
///   }
/// }
/// ```
///
/// No main.dart, envolva o app com:
/// ```dart
/// MultiProvider(
///   providers: [
///     ChangeNotifierProvider(create: (_) => LancamentoProvider()),
///   ],
///   child: const FinanceiroApp(),
/// )
/// ```
library;
