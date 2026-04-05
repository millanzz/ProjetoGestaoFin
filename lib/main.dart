import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'core/app_routes.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const FinanceiroApp());
}

class FinanceiroApp extends StatelessWidget {
  const FinanceiroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Financeiro App',
      theme: AppTheme.theme,
      initialRoute: AuthService.isLogged() ? AppRoutes.home : AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}
