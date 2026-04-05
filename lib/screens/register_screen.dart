import 'package:flutter/material.dart';
import '../core/app_routes.dart';
import '../core/app_theme.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
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
          /// Fundo
          Container(
            height: 300,
            decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
          ),

          /// Back
          Positioned(
            top: 50,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.black45,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          /// Card
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(25),
              height: MediaQuery.of(context).size.height * 0.8,
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
                      "Get Started",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  _buildInput(
                    label: "Full Name",
                    controller: _nomeController,
                  ),
                  const SizedBox(height: 15),
                  _buildInput(
                    label: "Email",
                    controller: _emailController,
                  ),
                  const SizedBox(height: 15),
                  _buildInput(
                    label: "Password",
                    controller: _senhaController,
                    obscure: true,
                  ),
                  const SizedBox(height: 10),

                  const Row(
                    children: [
                      Checkbox(value: true, onChanged: null),
                      Expanded(
                        child: Text(
                          "I agree to the processing of Personal data",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Botão cadastrar
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _fazerCadastro,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppTheme.inputRadius,
                          ),
                        ),
                      ),
                      child: const Text("Sign up"),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Center(child: Text("Sign up with")),
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          "Sign in",
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

  void _fazerCadastro() {
    final nome = _nomeController.text.trim();
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();

    if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos")),
      );
      return;
    }

    AuthService.register(nome: nome, email: email);

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.home,
      (route) => false,
    );
  }

  Widget _buildInput({
    required String label,
    required TextEditingController controller,
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
            hintText: "Enter $label",
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
