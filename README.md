# Financeiro App

App mobile de controle financeiro pessoal.  
**Stack:** Flutter (front) · Node.js (back) · SQLite (banco de dados)

---

## Índice

1. [Para o time de front — modo mock](#1-para-o-time-de-front--modo-mock)
2. [Para o time de back — contrato da API](#2-para-o-time-de-back--contrato-da-api)
3. [Para o time de banco — schema SQLite](#3-para-o-time-de-banco--schema-sqlite)
4. [Conectando front com backend real](#4-conectando-front-com-backend-real)
5. [Estrutura de pastas do projeto Flutter](#5-estrutura-de-pastas-do-projeto-flutter)
6. [Dependências](#6-dependências)

---

## 1. Para o time de front — modo mock

Enquanto o backend não está pronto, o app roda com dados fictícios locais.  
A chave que controla isso fica em **`lib/services/api_service.dart`**, linha 1:

```dart
const bool kUseMock = true;   // ← true  = dados fictícios, sem backend
                               // ← false = conecta no servidor Node.js real
```

### O que acontece com kUseMock = true

- Login aceita **qualquer e-mail e senha** que não estejam vazios
- Todos os dados (lançamentos, metas, resumo) são retornados pela classe `_Mock` no próprio arquivo
- Um delay de 600ms é simulado para que os estados de loading apareçam normalmente
- Nenhuma requisição HTTP é feita — o app funciona sem rede

### O que acontece com kUseMock = false

- O app passa a chamar o servidor Node.js na URL definida em `kBaseUrl`
- Login, cadastro e todas as operações exigem o backend rodando
- O token JWT retornado pelo login é salvo automaticamente e enviado em todas as requisições seguintes

### Editando os dados de teste

Os dados fictícios ficam na classe `_Mock` no final de `api_service.dart`.  
Edite à vontade para testar cenários diferentes (ex: saldo negativo, metas zeradas, lista vazia):

```dart
static Future<Map<String, dynamic>> get resumo async {
  return {
    'saldo': 3800.00,   // ← altere aqui
    'entradas': 5000.00,
    'saidas': 1200.00,
  };
}
```

---

## 2. Para o time de back — contrato da API

O backend deve ser um servidor **Node.js** (Express ou similar) na porta `3000`.  
Todos os endpoints protegidos exigem o header:

```
Authorization: Bearer <token_jwt>
```

O token é gerado no login/cadastro e deve ser um JWT válido com expiração.

---

### POST `/auth/login`

Autentica um usuário existente.

**Body:**
```json
{
  "email": "gustavo@email.com",
  "password": "senha123"
}
```

**Resposta 200:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "nome": "Gustavo",
    "email": "gustavo@email.com"
  }
}
```

**Resposta 401** (credenciais inválidas):
```json
{ "message": "Credenciais inválidas" }
```

---

### POST `/auth/register`

Cria um novo usuário e já retorna o token para entrar direto no app.

**Body:**
```json
{
  "nome": "Gustavo",
  "email": "gustavo@email.com",
  "password": "senha123"
}
```

**Resposta 201:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "nome": "Gustavo",
    "email": "gustavo@email.com"
  }
}
```

**Resposta 409** (e-mail já cadastrado):
```json
{ "message": "E-mail já está em uso" }
```

---

### GET `/lancamentos` 🔒

Retorna todos os lançamentos do usuário autenticado.

**Resposta 200:**
```json
{
  "data": [
    {
      "id": 1,
      "titulo": "Salário",
      "valor": 4000.00,
      "data": "2026-03-01T00:00:00.000Z",
      "tipo": "receita",
      "categoria": "Salário",
      "parcelado": 0
    },
    {
      "id": 2,
      "titulo": "Mercado",
      "valor": 350.00,
      "data": "2026-03-05T00:00:00.000Z",
      "tipo": "despesa",
      "categoria": "Alimentação",
      "parcelado": 0
    }
  ]
}
```

> `tipo` deve ser exatamente `"receita"` ou `"despesa"` (string em minúsculo).  
> `parcelado` deve ser `0` ou `1` (inteiro, padrão SQLite para boolean).  
> `data` deve estar no formato ISO 8601.

---

### POST `/lancamentos` 🔒

Cria um novo lançamento vinculado ao usuário autenticado.

**Body:**
```json
{
  "titulo": "Academia",
  "valor": 100.00,
  "data": "2026-03-20T00:00:00.000Z",
  "tipo": "despesa",
  "categoria": "Saúde",
  "parcelado": 0
}
```

**Resposta 201:**
```json
{
  "data": {
    "id": 7,
    "titulo": "Academia",
    "valor": 100.00,
    "data": "2026-03-20T00:00:00.000Z",
    "tipo": "despesa",
    "categoria": "Saúde",
    "parcelado": 0
  }
}
```

> O objeto retornado em `data` deve conter o `id` gerado pelo banco.  
> O front usa esse `id` para operações futuras como delete.

---

### DELETE `/lancamentos/:id` 🔒

Remove um lançamento pelo ID.

**Resposta 200:**
```json
{ "message": "Deletado com sucesso" }
```

**Resposta 404:**
```json
{ "message": "Lançamento não encontrado" }
```

---

### GET `/metas` 🔒

Retorna as metas financeiras do usuário autenticado.

**Resposta 200:**
```json
{
  "data": [
    {
      "id": 1,
      "titulo": "Notebook",
      "valor_atual": 900.00,
      "valor_meta": 2000.00,
      "icone": "💻"
    },
    {
      "id": 2,
      "titulo": "Viagem",
      "valor_atual": 5600.00,
      "valor_meta": 8000.00,
      "icone": "🏝️"
    }
  ]
}
```

> Os campos são `valor_atual` e `valor_meta` (com underscore), não `valorAtual`.  
> O front converte via `fromJson()` no model.

---

### POST `/metas` 🔒

Cria uma nova meta.

**Body:**
```json
{
  "titulo": "Carro",
  "valor_atual": 0.00,
  "valor_meta": 30000.00,
  "icone": "🚗"
}
```

**Resposta 201:**
```json
{
  "data": {
    "id": 3,
    "titulo": "Carro",
    "valor_atual": 0.00,
    "valor_meta": 30000.00,
    "icone": "🚗"
  }
}
```

---

### GET `/resumo/mes` 🔒

Retorna o resumo financeiro do mês atual do usuário autenticado.  
O backend deve calcular automaticamente com base nos lançamentos do mês corrente.

**Resposta 200:**
```json
{
  "saldo": 3800.00,
  "entradas": 5000.00,
  "saidas": 1200.00
}
```

> `saldo` = `entradas` - `saidas` no mês atual.  
> O filtro de mês deve ser feito no backend, não no front.

---

### Regras gerais da API

| Regra | Detalhe |
|-------|---------|
| Formato | Sempre `Content-Type: application/json` |
| Autenticação | JWT via header `Authorization: Bearer <token>` |
| Token expirado | Retornar `401` com `{ "message": "Token inválido ou expirado" }` |
| Erros de servidor | Retornar `500` com `{ "message": "Erro interno" }` |
| Isolamento de dados | Cada usuário só acessa seus próprios lançamentos e metas (filtrar por `user_id` no banco) |

---

## 3. Para o time de banco — schema SQLite

O banco é **SQLite** gerenciado pelo backend Node.js.  
Abaixo o schema esperado para que o contrato da API funcione corretamente.

```sql
-- Usuários
CREATE TABLE users (
  id         INTEGER PRIMARY KEY AUTOINCREMENT,
  nome       TEXT    NOT NULL,
  email      TEXT    NOT NULL UNIQUE,
  password   TEXT    NOT NULL,  -- hash bcrypt, nunca texto puro
  created_at TEXT    DEFAULT (datetime('now'))
);

-- Lançamentos (receitas e despesas)
CREATE TABLE lancamentos (
  id         INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id    INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  titulo     TEXT    NOT NULL,
  valor      REAL    NOT NULL,
  data       TEXT    NOT NULL,  -- ISO 8601: "2026-03-20T00:00:00.000Z"
  tipo       TEXT    NOT NULL CHECK(tipo IN ('receita', 'despesa')),
  categoria  TEXT,
  parcelado  INTEGER NOT NULL DEFAULT 0 CHECK(parcelado IN (0, 1)),
  created_at TEXT    DEFAULT (datetime('now'))
);

-- Metas financeiras
CREATE TABLE metas (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id     INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  titulo      TEXT    NOT NULL,
  valor_atual REAL    NOT NULL DEFAULT 0,
  valor_meta  REAL    NOT NULL,
  icone       TEXT    DEFAULT '🎯',
  created_at  TEXT    DEFAULT (datetime('now'))
);
```

### Índices recomendados

```sql
-- Acelera as queries de lançamentos por usuário e mês
CREATE INDEX idx_lancamentos_user_id ON lancamentos(user_id);
CREATE INDEX idx_lancamentos_data    ON lancamentos(data);
CREATE INDEX idx_metas_user_id       ON metas(user_id);
```

### Query do resumo mensal

Esta é a query que o endpoint `GET /resumo/mes` precisa executar:

```sql
SELECT
  COALESCE(SUM(CASE WHEN tipo = 'receita' THEN valor ELSE 0 END), 0) AS entradas,
  COALESCE(SUM(CASE WHEN tipo = 'despesa' THEN valor ELSE 0 END), 0) AS saidas,
  COALESCE(SUM(CASE WHEN tipo = 'receita' THEN valor ELSE -valor END), 0) AS saldo
FROM lancamentos
WHERE
  user_id = ?
  AND strftime('%Y-%m', data) = strftime('%Y-%m', 'now');
```

### Observações importantes

- **Senhas** nunca devem ser salvas em texto puro — usar `bcrypt` com salt rounds ≥ 10
- **`parcelado`** é `INTEGER 0/1` no SQLite (não existe tipo boolean nativo)
- **`data`** é `TEXT` no SQLite — salvar em ISO 8601 para que `strftime` funcione corretamente
- **`ON DELETE CASCADE`** garante que ao deletar um usuário seus lançamentos e metas sejam removidos automaticamente

---

## 4. Conectando front com backend real

Quando o backend estiver pronto, dois passos no front:

**Passo 1** — Desativar o mock em `lib/services/api_service.dart`:
```dart
const bool kUseMock = false;
```

**Passo 2** — Ajustar a URL do servidor na mesma linha abaixo:
```dart
// Android Emulator (aponta para o localhost da máquina host via NAT)
const String kBaseUrl = 'http://10.0.2.2:3000';

// iOS Simulator
const String kBaseUrl = 'http://localhost:3000';

// Dispositivo físico (substitua pelo IP da máquina na rede local)
const String kBaseUrl = 'http://192.168.0.X:3000';

// Produção
const String kBaseUrl = 'https://api.seudominio.com';
```

Só isso — nenhum outro arquivo precisa ser alterado.

---

## 5. Estrutura de pastas do projeto Flutter

```
lib/
├── auth/
│   ├── auth_service.dart        ← Persiste e recupera o token JWT (SharedPreferences)
│   ├── login_screen.dart        ← Tela de login
│   └── register_screen.dart     ← Tela de cadastro
│
├── models/
│   ├── lancamento_model.dart    ← Model com fromJson / toJson
│   └── meta_model.dart          ← Model com fromJson / toJson
│
├── providers/
│   └── financeiro_provider.dart ← Estado global do app (ChangeNotifier + Provider)
│
├── services/
│   └── api_service.dart         ← Todas as chamadas HTTP + classe _Mock
│
├── screens/
│   ├── home_screen.dart
│   ├── entrada_screen.dart
│   ├── despesa_screen.dart
│   ├── historico_screen.dart
│   ├── metas_screen.dart
│   ├── nova_entrada_screen.dart
│   ├── nova_despesa_screen.dart
│   ├── perfil_screen.dart
│   └── main_navigation_screen.dart
│
└── widgets/
    ├── lancamento_form.dart
    ├── saldo_card.dart
    ├── resumo_card.dart
    ├── meta_card.dart
    ├── lancamento_item.dart
    ├── historico_item.dart
    ├── grafico_financeiro.dart
    └── opcao_button.dart
```

---

## 6. Dependências

Adicionar ao `pubspec.yaml` e rodar `flutter pub get`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2          # gerenciamento de estado global
  http: ^1.2.1               # requisições HTTP ao backend
  shared_preferences: ^2.2.3 # persistência local do token JWT
```
