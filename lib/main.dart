import 'package:flutter/material.dart';
import 'auth/auth_service.dart';
import 'auth/login_screen.dart';
import 'screens/main_navigation_screen.dart';

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
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AuthService.isLogged()
          ? const MainNavigationScreen()
          : const LoginScreen(),
    );
  }
}



