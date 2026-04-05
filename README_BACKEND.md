# Financeiro App — Guia de Integração com Backend

## Visão geral do projeto

App de finanças pessoais em Flutter com controle de receitas, despesas, metas e histórico. Hoje roda 100% local (dados em memória). Este guia mostra como conectar cada parte ao backend sem quebrar nada.

## Estrutura atual

```
lib/
├── main.dart                          # Entry point
├── core/
│   ├── app_theme.dart                 # Cores, gradientes, bordas
│   └── app_routes.dart                # Rotas nomeadas
├── models/
│   ├── lancamento_model.dart          # toMap() / fromMap() prontos
│   └── meta_model.dart                # toMap() / fromMap() prontos
├── services/
│   ├── auth_service.dart              # Login/logout em memória
│   └── lancamento_service.dart        # CRUD local + totais
├── providers/                         # (vazio — criar na Etapa 2)
├── screens/
│   ├── main_navigation_screen.dart
│   ├── home_screen.dart
│   ├── lancamentos_screen.dart
│   ├── lancamento_form_screen.dart
│   ├── historico_screen.dart
│   ├── metas_screen.dart
│   ├── perfil_screen.dart
│   ├── login_screen.dart
│   └── register_screen.dart
└── widgets/
    ├── saldo_card.dart
    ├── resumo_card.dart
    ├── opcao_button.dart
    ├── meta_card.dart
    ├── grafico_pizza.dart
    └── grafico_barras.dart
```

## O que já está preparado

Os models já possuem `toMap()` e `fromMap()` — basta renomear para `toJson()` / `fromJson()` ou usar como estão. Os services centralizam todo acesso a dados, então as telas nunca acessam dados diretamente. Os gráficos recebem dados como parâmetro (lista de lançamentos ou valores), então funcionam automaticamente quando a fonte de dados mudar.

---

## Etapa 1 — Escolher o backend

Existem três caminhos comuns para Flutter. Escolha um:

### Opção A: Firebase (mais rápido para começar)

Ideal se você quer autenticação, banco de dados e deploy sem montar servidor.

Dependências no `pubspec.yaml`:

```yaml
dependencies:
  firebase_core: ^3.8.1
  firebase_auth: ^5.4.1
  cloud_firestore: ^5.6.1
```

Configuração inicial:

```bash
# Instalar CLI
dart pub global activate flutterfire_cli

# Configurar projeto (gera firebase_options.dart)
flutterfire configure
```

No `main.dart`, inicializar antes do `runApp`:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const FinanceiroApp());
}
```

### Opção B: API REST própria (mais controle)

Ideal se você já tem ou quer construir um backend em Node.js, Django, Spring, etc.

Dependências no `pubspec.yaml`:

```yaml
dependencies:
  http: ^1.2.2
```

Criar um arquivo de configuração em `lib/core/api_config.dart`:

```dart
class ApiConfig {
  static const String baseUrl = 'https://sua-api.com/api';

  // Endpoints
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';
  static const String lancamentos = '$baseUrl/lancamentos';
  static const String metas = '$baseUrl/metas';
}
```

### Opção C: SQLite local (offline first)

Ideal se quer funcionar sem internet e sincronizar depois.

```yaml
dependencies:
  sqflite: ^2.4.1
  path: ^1.9.0
```

---

## Etapa 2 — Gerenciamento de estado com Provider

Hoje as telas leem dados direto dos services (métodos estáticos). Isso funciona, mas não atualiza a UI quando os dados mudam. O Provider resolve isso.

### 2.1 Adicionar dependência

```yaml
dependencies:
  provider: ^6.1.2
```

### 2.2 Criar LancamentoProvider

Criar o arquivo `lib/providers/lancamento_provider.dart`:

```dart
import 'package:flutter/material.dart';
import '../models/lancamento_model.dart';
import '../services/lancamento_service.dart';

class LancamentoProvider extends ChangeNotifier {
  List<LancamentoModel> _lancamentos = [];
  bool _loading = false;
  String? _erro;

  List<LancamentoModel> get lancamentos => _lancamentos;
  bool get loading => _loading;
  String? get erro => _erro;

  List<LancamentoModel> get receitas =>
      _lancamentos.where((l) => l.isReceita).toList();

  List<LancamentoModel> get despesas =>
      _lancamentos.where((l) => !l.isReceita).toList();

  double get totalReceitas =>
      receitas.fold(0, (sum, l) => sum + l.valor);

  double get totalDespesas =>
      despesas.fold(0, (sum, l) => sum + l.valor);

  double get saldo => totalReceitas - totalDespesas;

  Future<void> carregar() async {
    _loading = true;
    _erro = null;
    notifyListeners();

    try {
      _lancamentos = await LancamentoService.fetchAll();
    } catch (e) {
      _erro = 'Erro ao carregar lançamentos';
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> adicionar(LancamentoModel lancamento) async {
    try {
      await LancamentoService.create(lancamento);
      await carregar();
    } catch (e) {
      _erro = 'Erro ao salvar lançamento';
      notifyListeners();
    }
  }

  Future<void> remover(String id) async {
    try {
      await LancamentoService.delete(id);
      await carregar();
    } catch (e) {
      _erro = 'Erro ao remover lançamento';
      notifyListeners();
    }
  }
}
```

### 2.3 Criar AuthProvider

Criar o arquivo `lib/providers/auth_provider.dart`:

```dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _loading = false;
  String? _erro;

  bool get loading => _loading;
  bool get isLogged => AuthService.isLogged();
  String get nome => AuthService.nome;
  String get email => AuthService.email;
  String get iniciais => AuthService.iniciais;
  String? get erro => _erro;

  Future<bool> login(String email, String senha) async {
    _loading = true;
    _erro = null;
    notifyListeners();

    try {
      await AuthService.loginWithEmail(email, senha);
      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _erro = 'Email ou senha inválidos';
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String nome, String email, String senha) async {
    _loading = true;
    _erro = null;
    notifyListeners();

    try {
      await AuthService.registerWithEmail(nome, email, senha);
      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _erro = 'Erro ao criar conta';
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    AuthService.logout();
    notifyListeners();
  }
}
```

### 2.4 Registrar providers no main.dart

```dart
import 'package:provider/provider.dart';
import 'providers/lancamento_provider.dart';
import 'providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(...);  // se usar Firebase

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LancamentoProvider()),
      ],
      child: const FinanceiroApp(),
    ),
  );
}
```

### 2.5 Usar nas telas

Onde antes tinha chamada estática, usar `context.watch` ou `context.read`:

```dart
// ANTES (estático, não reativo)
final saldo = LancamentoService.saldo;

// DEPOIS (reativo, atualiza a UI)
final provider = context.watch<LancamentoProvider>();
final saldo = provider.saldo;

// Para ações (adicionar, remover)
context.read<LancamentoProvider>().adicionar(lancamento);
```

---

## Etapa 3 — Converter os services para async

Transformar os métodos estáticos síncronos em chamadas assíncronas ao backend.

### 3.1 AuthService com Firebase

```dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;

  static bool isLogged() => _auth.currentUser != null;
  static String get nome => _auth.currentUser?.displayName ?? '';
  static String get email => _auth.currentUser?.email ?? '';

  static String get iniciais {
    if (nome.isEmpty) return '?';
    final partes = nome.trim().split(' ');
    if (partes.length >= 2) {
      return '${partes.first[0]}${partes.last[0]}'.toUpperCase();
    }
    return partes.first[0].toUpperCase();
  }

  static Future<void> loginWithEmail(String email, String senha) async {
    await _auth.signInWithEmailAndPassword(email: email, password: senha);
  }

  static Future<void> registerWithEmail(
    String nome, String email, String senha,
  ) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email, password: senha,
    );
    await credential.user?.updateDisplayName(nome);
  }

  static Future<void> logout() async {
    await _auth.signOut();
  }
}
```

### 3.2 AuthService com API REST

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';

class AuthService {
  static String _token = '';
  static String _nome = '';
  static String _email = '';

  static bool isLogged() => _token.isNotEmpty;
  static String get nome => _nome;
  static String get email => _email;
  static String get token => _token;

  static String get iniciais {
    if (_nome.isEmpty) return '?';
    final partes = _nome.trim().split(' ');
    if (partes.length >= 2) {
      return '${partes.first[0]}${partes.last[0]}'.toUpperCase();
    }
    return partes.first[0].toUpperCase();
  }

  static Future<void> loginWithEmail(String email, String senha) async {
    final response = await http.post(
      Uri.parse(ApiConfig.login),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': senha}),
    );

    if (response.statusCode != 200) {
      throw Exception('Login falhou');
    }

    final data = jsonDecode(response.body);
    _token = data['token'];
    _nome = data['user']['name'];
    _email = data['user']['email'];
  }

  static Future<void> registerWithEmail(
    String nome, String email, String senha,
  ) async {
    final response = await http.post(
      Uri.parse(ApiConfig.register),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': nome,
        'email': email,
        'password': senha,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Cadastro falhou');
    }

    await loginWithEmail(email, senha);
  }

  static void logout() {
    _token = '';
    _nome = '';
    _email = '';
  }
}
```

### 3.3 LancamentoService com Firebase

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/lancamento_model.dart';

class LancamentoService {
  static final _db = FirebaseFirestore.instance;
  static String get _userId => FirebaseAuth.instance.currentUser!.uid;

  static CollectionReference get _collection =>
      _db.collection('users').doc(_userId).collection('lancamentos');

  static Future<List<LancamentoModel>> fetchAll() async {
    final snapshot = await _collection.orderBy('data', descending: true).get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return LancamentoModel.fromMap(data);
    }).toList();
  }

  static Future<void> create(LancamentoModel lancamento) async {
    await _collection.add(lancamento.toMap());
  }

  static Future<void> update(LancamentoModel lancamento) async {
    await _collection.doc(lancamento.id).update(lancamento.toMap());
  }

  static Future<void> delete(String id) async {
    await _collection.doc(id).delete();
  }
}
```

### 3.4 LancamentoService com API REST

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import '../models/lancamento_model.dart';
import 'auth_service.dart';

class LancamentoService {
  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthService.token}',
      };

  static Future<List<LancamentoModel>> fetchAll() async {
    final response = await http.get(
      Uri.parse(ApiConfig.lancamentos),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar lançamentos');
    }

    final List data = jsonDecode(response.body);
    return data.map((e) => LancamentoModel.fromMap(e)).toList();
  }

  static Future<void> create(LancamentoModel lancamento) async {
    final response = await http.post(
      Uri.parse(ApiConfig.lancamentos),
      headers: _headers,
      body: jsonEncode(lancamento.toMap()),
    );

    if (response.statusCode != 201) {
      throw Exception('Erro ao criar lançamento');
    }
  }

  static Future<void> delete(String id) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.lancamentos}/$id'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar lançamento');
    }
  }
}
```

---

## Etapa 4 — Atualizar as telas

As mudanças nas telas são mínimas porque a lógica já está centralizada nos services.

### 4.1 LoginScreen

```dart
// ANTES
AuthService.login(email: email);
Navigator.pushReplacementNamed(context, AppRoutes.home);

// DEPOIS
final auth = context.read<AuthProvider>();
final sucesso = await auth.login(email, senha);
if (sucesso) {
  Navigator.pushReplacementNamed(context, AppRoutes.home);
} else {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(auth.erro ?? 'Erro ao fazer login')),
  );
}
```

### 4.2 HomeScreen

```dart
// ANTES
final saldo = LancamentoService.saldo;
final entradaMes = LancamentoService.totalReceitas;
Text("Olá, ${AuthService.nome},");

// DEPOIS
final lancamentos = context.watch<LancamentoProvider>();
final auth = context.watch<AuthProvider>();
final saldo = lancamentos.saldo;
final entradaMes = lancamentos.totalReceitas;
Text("Olá, ${auth.nome},");
```

### 4.3 LancamentoFormScreen

```dart
// ANTES
LancamentoService.adicionar(lancamento);
Navigator.pop(context);

// DEPOIS
await context.read<LancamentoProvider>().adicionar(lancamento);
Navigator.pop(context);
```

### 4.4 Telas com loading

Envolver o conteúdo com verificação de loading:

```dart
final provider = context.watch<LancamentoProvider>();

if (provider.loading) {
  return const Center(child: CircularProgressIndicator());
}

if (provider.erro != null) {
  return Center(child: Text(provider.erro!));
}

// ... conteúdo normal usando provider.lancamentos
```

---

## Etapa 5 — Carregar dados na inicialização

No `MainNavigationScreen`, carregar dados quando a tela abre:

```dart
@override
void initState() {
  super.initState();
  // Carrega dados assim que entra no app
  Future.microtask(() {
    context.read<LancamentoProvider>().carregar();
  });
}
```

---

## Checklist final

- [ ] Escolher backend (Firebase / API REST / SQLite)
- [ ] Adicionar dependências no `pubspec.yaml`
- [ ] Configurar projeto (Firebase CLI ou `api_config.dart`)
- [ ] Criar `LancamentoProvider` e `AuthProvider` em `lib/providers/`
- [ ] Registrar providers no `main.dart` com `MultiProvider`
- [ ] Converter `AuthService` para async
- [ ] Converter `LancamentoService` para async
- [ ] Atualizar telas: trocar chamadas estáticas por `context.watch/read`
- [ ] Adicionar loading e tratamento de erro nas telas
- [ ] Testar login, cadastro, CRUD de lançamentos
- [ ] Repetir o processo para `MetaService` (mesmo padrão)

---

## Ordem recomendada de implementação

1. Provider + AuthService (login/cadastro funcionando com backend)
2. LancamentoService (CRUD de receitas e despesas)
3. MetaService (mesmo padrão do LancamentoService)
4. Filtros no histórico (query por data no backend)
5. Notificações push (opcional)

Os gráficos, cards e widgets não precisam de nenhuma alteração — eles já recebem dados como parâmetro e vão funcionar automaticamente quando o provider alimentar as telas com dados reais.
