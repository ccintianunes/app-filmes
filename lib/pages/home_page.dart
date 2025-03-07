import 'package:flutter/material.dart';
import '../services/database.dart';
import '../models/filme.dart';
import '../widgets/filme_card.dart';
import 'cadastro_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService _database = DatabaseService();
  List<Filme> _listaFilmes = [];

  @override
  void initState() {
    super.initState();
    _atualizarListaFilmes();
  }

  Future<void> _atualizarListaFilmes() async {
    final filmes = await _database.getFilmes();
    setState(() => _listaFilmes = filmes);
  }

  Future<void> _abrirTelaCadastro({Filme? filme}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CadastroScreen(filme: filme)),
    );
    _atualizarListaFilmes();
  }

  Future<void> _removerFilme(int id) async {
    await _database.deleteFilme(id);
    _mostrarSnackbar('Filme removido com sucesso!');
    _atualizarListaFilmes();
  }

  void _mostrarSnackbar(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  void _ordenarFilmes(String criterio) {
    setState(() {
      switch (criterio) {
        case 'titulo':
          _listaFilmes.sort((a, b) => a.titulo.compareTo(b.titulo));
          break;
        case 'ano':
          _listaFilmes.sort((a, b) => a.ano.compareTo(b.ano));
          break;
        case 'nota':
          _listaFilmes.sort((a, b) => b.nota.compareTo(a.nota)); 
          break;
      }
    });
  }


      body: Padding(
        padding: const EdgeInsets.all(8.0), 
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.6,
          ),
          itemCount: _listaFilmes.length,
          itemBuilder: (context, index) {
            final filme = _listaFilmes[index];
            return AnimatedFilmeCard(
              filme: filme,
              onTap: () => _abrirTelaCadastro(filme: filme),
              onLongPress: () => _removerFilme(filme.id),
              index: index,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirTelaCadastro(),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add),
      ),
    );
  }
}
