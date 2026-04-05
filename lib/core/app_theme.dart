import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Cores principais
  static const Color primaryBlue = Color(0xff4e73df);
  static const Color lightBlue = Color(0xff6ea8fe);
  static const Color background = Color(0xfff5f6fa);
  static const Color inputFill = Color(0xfff2f4f7);
  static const Color cardBackground = Colors.white;

  // Gradiente padrão
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [lightBlue, primaryBlue],
  );

  // Bordas
  static const double cardRadius = 20;
  static const double inputRadius = 12;
  static const double buttonRadius = 15;

  // Tema do app
  static ThemeData get theme => ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: background,
        appBarTheme: const AppBarTheme(
          backgroundColor: background,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primaryBlue,
        ),
      );
}
