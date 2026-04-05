/// Serviço de autenticação.
/// Guarda os dados do usuário logado em memória.
/// Futuramente: integrar com Firebase Auth, JWT, etc.
class AuthService {
  static bool _isLogged = false;
  static String _nome = '';
  static String _email = '';

  static bool isLogged() => _isLogged;

  static String get nome => _nome;
  static String get email => _email;

  /// Iniciais do nome para o avatar placeholder
  static String get iniciais {
    if (_nome.isEmpty) return '?';
    final partes = _nome.trim().split(' ');
    if (partes.length >= 2) {
      return '${partes.first[0]}${partes.last[0]}'.toUpperCase();
    }
    return partes.first[0].toUpperCase();
  }

  static void login({required String email, String? nome}) {
    _isLogged = true;
    _email = email;
    if (nome != null && nome.isNotEmpty) {
      _nome = nome;
    } else {
      // Extrai nome do email se não foi fornecido
      _nome = email.split('@').first;
    }
  }

  static void register({
    required String nome,
    required String email,
  }) {
    _nome = nome;
    _email = email;
    _isLogged = true;
  }

  static void logout() {
    _isLogged = false;
    _nome = '';
    _email = '';
  }
}
