import 'package:flutter/material.dart';
import '../core/app_routes.dart';
import '../core/app_theme.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          /// Fundo azul
          Container(
            height: 300,
            decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
          ),

          /// Card
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(25),
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
                color: AppTheme.cardBackground,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Welcome back",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  /// Email
                  _buildInput(
                    label: "Email",
                    hint: "seu@email.com",
                    controller: _emailController,
                  ),
                  const SizedBox(height: 15),

                  /// Senha
                  _buildInput(
                    label: "Password",
                    hint: "********",
                    controller: _senhaController,
                    obscure: true,
                  ),
                  const SizedBox(height: 10),

                  /// Remember + Forgot
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(value: true, onChanged: null),
                          Text("Remember me"),
                        ],
                      ),
                      Text(
                        "Forgot password?",
                        style: TextStyle(color: AppTheme.primaryBlue),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Botão login
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _fazerLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppTheme.inputRadius,
                          ),
                        ),
                      ),
                      child: const Text("Sign in"),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Center(child: Text("Sign in with")),
                  const SizedBox(height: 15),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.facebook, color: Colors.blue),
                      Icon(Icons.flutter_dash),
                      Icon(Icons.g_mobiledata, color: Colors.red),
                      Icon(Icons.apple),
                    ],
                  ),

                  const Spacer(),

                  /// Ir para cadastro
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.register,
                        ),
                        child: const Text(
                          "Sign up",
                          style: TextStyle(
                            color: AppTheme.primaryBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _fazerLogin() {
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha email e senha")),
      );
      return;
    }

    AuthService.login(email: email);

    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  Widget _buildInput({
    required String label,
    required TextEditingController controller,
    String? hint,
    bool obscure = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint ?? "Enter $label",
            filled: true,
            fillColor: AppTheme.inputFill,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.inputRadius),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
