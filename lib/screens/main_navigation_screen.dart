import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'entrada_screen.dart';
import 'despesa_screen.dart';
import 'metas_screen.dart';
import 'historico_screen.dart';
import 'perfil_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _lectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    EntradaScreen(),
    DespesaScreen(),
    MetasScreen(),
    HistoricoScreen(),
    PerfilScreen(),
  ];

  void _onItemTapped(int index) {


    setState(() {
      _lectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_lectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _lectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Entrada"),
          BottomNavigationBarItem(icon: Icon(Icons.remove), label: "Despesa"),
          BottomNavigationBarItem(icon: Icon(Icons.flag), label: "Metas"),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "Histórico",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ],
      ),
    );
  }
}
