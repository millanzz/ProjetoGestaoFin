import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../models/lancamento_model.dart';
import '../services/lancamento_service.dart';

class LancamentoFormScreen extends StatefulWidget {
  final String titulo;
  final String textoBotao;
  final TipoLancamento tipo;
  final List<String> categorias;

  const LancamentoFormScreen({
    super.key,
    required this.titulo,
    required this.textoBotao,
    required this.tipo,
    required this.categorias,
  });

  @override
  State<LancamentoFormScreen> createState() => _LancamentoFormScreenState();
}

class _LancamentoFormScreenState extends State<LancamentoFormScreen> {
  final _valorController = TextEditingController();
  final _descricaoController = TextEditingController();

  DateTime _dataSelecionada = DateTime.now();
  String? _categoriaSelecionada;
  bool _parcelado = false;

  bool get _isReceita => widget.tipo == TipoLancamento.receita;

  @override
  void dispose() {
    _valorController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
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

            Text(
              widget.titulo,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            /// Card formulário
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                borderRadius: BorderRadius.circular(AppTheme.cardRadius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCampo(
                    label: "Valor (R\$)",
                    child: TextField(
                      controller: _valorController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration("R\$ 0,00"),
                    ),
                  ),

                  _buildCampo(
                    label: "Descrição",
                    child: TextField(
                      controller: _descricaoController,
                      decoration: _inputDecoration(
                        "Ex: Supermercado, Conta de Luz...",
                      ),
                    ),
                  ),

                  _buildCampo(
                    label: "Categoria",
                    child: DropdownButtonFormField<String>(
                      value: _categoriaSelecionada,
                      items: widget.categorias
                          .map((cat) => DropdownMenuItem(
                                value: cat,
                                child: Text(cat),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() => _categoriaSelecionada = value);
                      },
                      decoration: _inputDecoration("Selecionar"),
                    ),
                  ),

                  _buildCampo(
                    label: "Data",
                    child: TextField(
                      readOnly: true,
                      decoration: _inputDecoration(
                        "${_dataSelecionada.day.toString().padLeft(2, '0')}/"
                        "${_dataSelecionada.month.toString().padLeft(2, '0')}/"
                        "${_dataSelecionada.year}",
                      ).copyWith(
                        suffixIcon: const Icon(Icons.calendar_today),
                      ),
                      onTap: _selecionarData,
                    ),
                  ),

                  /// Parcelado
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Parcelado?"),
                      Row(
                        children: [
                          Switch(
                            value: _parcelado,
                            onChanged: (v) => setState(() => _parcelado = v),
                          ),
                          Text(_parcelado ? "Sim" : "Não"),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  /// Botão salvar
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _salvar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppTheme.buttonRadius,
                          ),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: _isReceita
                              ? const LinearGradient(
                                  colors: [
                                    AppTheme.lightBlue,
                                    AppTheme.primaryBlue,
                                  ],
                                )
                              : const LinearGradient(
                                  colors: [
                                    Color(0xffff7675),
                                    Color(0xffd63031),
                                  ],
                                ),
                          borderRadius: BorderRadius.circular(
                            AppTheme.buttonRadius,
                          ),
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

  Widget _buildCampo({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        child,
        const SizedBox(height: 20),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppTheme.inputFill,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.inputRadius),
        borderSide: BorderSide.none,
      ),
    );
  }

  Future<void> _selecionarData() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _dataSelecionada = picked);
    }
  }

  void _salvar() {
    final valorTexto = _valorController.text.replaceAll(',', '.');
    final valor = double.tryParse(valorTexto);

    if (valor == null || valor <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Informe um valor válido")),
      );
      return;
    }

    final lancamento = LancamentoModel(
      titulo: _descricaoController.text.isNotEmpty
          ? _descricaoController.text
          : (_categoriaSelecionada ?? "Sem descrição"),
      valor: valor,
      data: _dataSelecionada,
      tipo: widget.tipo,
      categoria: _categoriaSelecionada,
      parcelado: _parcelado,
    );

    LancamentoService.adicionar(lancamento);
    Navigator.pop(context);
  }
}
