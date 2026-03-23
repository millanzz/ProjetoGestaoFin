import 'package:flutter/material.dart';

class LancamentoForm extends StatefulWidget {
  final String titulo;
  final String textoBotao;
  final List<String> categorias;
  final bool isReceita;

  const LancamentoForm({
    super.key,
    required this.titulo,
    required this.textoBotao,
    required this.categorias,
    required this.isReceita,
  });

  @override
  State<LancamentoForm> createState() => _LancamentoFormState();
}

class _LancamentoFormState extends State<LancamentoForm> {
  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();

  DateTime _dataSelecionada = DateTime.now();
  String? _categoriaSelecionada;
  bool _parcelado = false;

  @override
  void dispose() {
    _valorController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),
      appBar: AppBar(
        backgroundColor: const Color(0xfff5f6fa),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 10),

            /// TÍTULO
            Text(
              widget.titulo,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            /// CARD FORMULÁRIO
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// VALOR
                  const Text("Valor (R\$)"),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _valorController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "R\$ 0,00",
                      filled: true,
                      fillColor: const Color(0xfff2f4f7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// DESCRIÇÃO
                  const Text("Descrição"),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descricaoController,
                    decoration: InputDecoration(
                      hintText: "Ex: Supermercado, Conta de Luz...",
                      filled: true,
                      fillColor: const Color(0xfff2f4f7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// CATEGORIA
                  const Text("Categoria"),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _categoriaSelecionada,
                    items: widget.categorias
                        .map(
                          (categoria) => DropdownMenuItem(
                        value: categoria,
                        child: Text(categoria),
                      ),
                    )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _categoriaSelecionada = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Selecionar",
                      filled: true,
                      fillColor: const Color(0xfff2f4f7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// DATA
                  const Text("Data"),
                  const SizedBox(height: 8),
                  TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText:
                      "${_dataSelecionada.day}/${_dataSelecionada.month}/${_dataSelecionada.year}",
                      filled: true,
                      fillColor: const Color(0xfff2f4f7),
                      suffixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _dataSelecionada,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );

                      if (picked != null) {
                        setState(() {
                          _dataSelecionada = picked;
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  /// PARCELADO
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Parcelado?"),
                      Row(
                        children: [
                          Switch(
                            value: _parcelado,
                            onChanged: (value) {
                              setState(() {
                                _parcelado = value;
                              });
                            },
                          ),
                          Text(_parcelado ? "Sim" : "Não"),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  /// BOTÃO SALVAR
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        _salvar();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: widget.isReceita
                                ? [
                              const Color(0xff6ea8fe),
                              const Color(0xff4e73df),
                            ]
                                : [
                              const Color(0xff6ea8fe),
                              const Color(0xff4e73df),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            widget.textoBotao,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _salvar() {
    print("Valor: ${_valorController.text}");
    print("Descrição: ${_descricaoController.text}");
    print("Categoria: $_categoriaSelecionada");
    print("Data: $_dataSelecionada");
    print("Parcelado: $_parcelado");
    print("Tipo: ${widget.isReceita ? "Receita" : "Despesa"}");

    Navigator.pop(context);
  }
}