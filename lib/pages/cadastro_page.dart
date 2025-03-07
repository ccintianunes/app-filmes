import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/filme.dart';
import '../services/database.dart';

class CadastroScreen extends StatefulWidget {
  final Filme? filme;

  const CadastroScreen({super.key, this.filme});

  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _tituloController;
  late final TextEditingController _anoController;
  late final TextEditingController _diretorController;
  late final TextEditingController _resumoController;
  double _nota = 0.0;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.filme?.titulo ?? '');
    _anoController = TextEditingController(text: widget.filme?.ano?.toString() ?? '');
    _diretorController = TextEditingController(text: widget.filme?.diretor ?? '');
    _resumoController = TextEditingController(text: widget.filme?.resumo ?? '');
    _nota = widget.filme?.nota ?? 0.0;
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _anoController.dispose();
    _diretorController.dispose();
    _resumoController.dispose();
    super.dispose();
  }

  String? _validarCampo(String? value, String mensagem) {
    return (value == null || value.isEmpty) ? mensagem : null;
  }

  Future<void> _salvarFilme() async {
    if (_formKey.currentState!.validate()) {
      final filme = Filme(
        id: widget.filme?.id ?? 0,
        titulo: _tituloController.text,
        ano: int.parse(_anoController.text),
        diretor: _diretorController.text,
        resumo: _resumoController.text,
        urlCartaz: widget.filme?.urlCartaz ?? '',
        nota: _nota,
      );

      final databaseService = DatabaseService();
      widget.filme == null
          ? await databaseService.insertFilme(filme)
          : await databaseService.updateFilme(filme);

      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.filme == null ? 'Adicionar Filme' : 'Editar Filme'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_tituloController, 'Título', 'Por favor, insira o título'),
              _buildTextField(_anoController, 'Ano', 'Por favor, insira o ano', TextInputType.number),
              _buildTextField(_diretorController, 'Direção', 'Por favor, insira a direção'),
              _buildTextField(_resumoController, 'Resumo', 'Por favor, insira o resumo', null, 3),
              const SizedBox(height: 20),
              const Text('Nota:'),
              _buildRatingBar(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarFilme,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String validationMessage, [
    TextInputType? keyboardType,
    int maxLines = 1,
  ]) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: (value) => _validarCampo(value, validationMessage),
    );
  }

  Widget _buildRatingBar() {
    return RatingBar.builder(
      initialRating: _nota,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: 30,
      itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
      onRatingUpdate: (rating) => setState(() => _nota = rating),
    );
  }
}
