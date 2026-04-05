import 'package:flutter/material.dart';
import '../core/app_routes.dart';
import '../core/app_theme.dart';
import '../services/auth_service.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  bool _notificacoesAtivas = true;

  @override
  Widget build(BuildContext context) {
    /// Verifica se tem rota anterior (veio via push)
    /// Se estiver como tab no BottomNav, não tem para onde voltar
    final podevoltar = Navigator.canPop(context);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: podevoltar
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        automaticallyImplyLeading: false,
        title: const Text("Perfil", style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// Avatar com iniciais do nome
            CircleAvatar(
              radius: 50,
              backgroundColor: AppTheme.primaryBlue,
              child: Text(
                AuthService.iniciais,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// Nome do usuário
            Text(
              AuthService.nome,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            /// Email do usuário
            Text(
              AuthService.email,
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 40),

            /// Notificações
            _buildCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Notificações", style: TextStyle(fontSize: 16)),
                  Switch(
                    value: _notificacoesAtivas,
                    onChanged: (v) => setState(() => _notificacoesAtivas = v),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// Sair
            GestureDetector(
              onTap: () => _confirmarSaida(context),
              child: _buildCard(
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Sair", style: TextStyle(fontSize: 16)),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  void _confirmarSaida(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Sair"),
        content: const Text("Deseja realmente sair da conta?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              AuthService.logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            },
            child: const Text("Sair"),
          ),
        ],
      ),
    );
  }
}
