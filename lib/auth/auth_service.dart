class AuthService {
  static bool _isLogged = false;

  static bool isLogged() {
    return _isLogged;
  }

  static void login() {
    _isLogged = true;
  }

  static void logout() {
    _isLogged = false;
  }
}