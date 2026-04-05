import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'lancamentos_screen.dart';
import 'metas_screen.dart';
import 'historico_screen.dart';
import 'perfil_screen.dart';
import '../models/lancamento_model.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    LancamentosScreen(tipo: TipoLancamento.receita),
    LancamentosScreen(tipo: TipoLancamento.despesa),
    MetasScreen(),
    HistoricoScreen(),
    PerfilScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Entrada"),
          BottomNavigationBarItem(icon: Icon(Icons.remove), label: "Despesa"),
          BottomNavigationBarItem(icon: Icon(Icons.flag), label: "Metas"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Histórico"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ],
      ),
    );
  }
}
