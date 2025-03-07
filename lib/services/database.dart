import 'dart:math';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/filme.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  static Database? _database;

  final List<String> _caminhosImagens = [
    'https://www.themoviedb.org/t/p/w600_and_h900_bestv2/9e3Dz7aCANy5aRUQF745IlNloJ1.jpg',
    'https://www.themoviedb.org/t/p/w600_and_h900_bestv2/7jvlqGsxeMKscskuUZgKk0Kuv99.jpg',
    'https://www.themoviedb.org/t/p/w600_and_h900_bestv2/bik2BZjmVjeE6LOZqtuTjb4jJPQ.jpg',
    'https://www.themoviedb.org/t/p/w600_and_h900_bestv2/r3pPehX4ik8NLYPpbDRAh0YRtMb.jpg',
    'https://www.themoviedb.org/t/p/w600_and_h900_bestv2/d74WpIsH8379TIL4wUxDneRCYv2.jpg',
  ];

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'filmes.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE filmes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT,
        ano INTEGER,
        diretor TEXT,
        resumo TEXT,
        url_cartaz TEXT,
        nota REAL
      )
    ''');

    // Inserção de filmes iniciais
    final filmesIniciais = [
      {
        'titulo': 'A Origem',
        'ano': 2010,
        'diretor': 'Christopher Nolan',
        'resumo': 'Um ladrão que invade os sonhos das pessoas para roubar segredos deve plantar uma ideia na mente de um alvo.',
        'url_cartaz': _caminhosImagens[0],
        'nota': 4.6,
      },
      {
        'titulo': 'Vingadores: Ultimato',
        'ano': 2019,
        'diretor': 'Anthony Russo, Joe Russo',
        'resumo': 'Os Vingadores tentam reverter os danos causados por Thanos e trazer de volta metade do universo.',
        'url_cartaz': _caminhosImagens[1],
        'nota': 4.8,
      },
      {
        'titulo': 'Parasita',
        'ano': 2019,
        'diretor': 'Bong Joon-ho',
        'resumo': 'Uma família pobre se infiltra na casa de uma família rica, mas o plano toma rumos inesperados.',
        'url_cartaz': _caminhosImagens[2],
        'nota': 4.9,
      },
      {
        'titulo': 'Clube da Luta',
        'ano': 1999,
        'diretor': 'David Fincher',
        'resumo': 'Um homem insatisfeito com sua vida forma um clube secreto de luta com um carismático vendedor de sabão.',
        'url_cartaz': _caminhosImagens[3],
        'nota': 4.5,
      },
      {
        'titulo': 'Forrest Gump',
        'ano': 1994,
        'diretor': 'Robert Zemeckis',
        'resumo': 'A história de um homem com QI abaixo da média que testemunha eventos históricos nos EUA.',
        'url_cartaz': _caminhosImagens[4],
        'nota': 4.7,
      }
    ];

    for (var filme in filmesIniciais) {
      await db.insert('filmes', filme);
    }
  }

  String _getImagemAleatoria() {
    final random = Random();
    return _caminhosImagens[random.nextInt(_caminhosImagens.length)];
  }

  Future<List<Filme>> getFilmes() async {
    final db = await database;
    final data = await db.query('filmes');
    return data.map((map) => Filme.fromMap(map)).toList();
  }

  Future<void> insertFilme(Filme filme) async {
    final db = await database;
    await db.insert('filmes', {
      'titulo': filme.titulo,
      'ano': filme.ano,
      'diretor': filme.diretor,
      'resumo': filme.resumo,
      'url_cartaz': filme.urlCartaz.isNotEmpty ? filme.urlCartaz : _getImagemAleatoria(),
      'nota': filme.nota,
    });
  }

  Future<void> updateFilme(Filme filme) async {
    final db = await database;
    await db.update(
      'filmes',
      {
        'titulo': filme.titulo,
        'ano': filme.ano,
        'diretor': filme.diretor,
        'resumo': filme.resumo,
        'nota': filme.nota,
      },
      where: 'id = ?',
      whereArgs: [filme.id],
    );
  }

  Future<void> deleteFilme(int id) async {
    final db = await database;
    await db.delete('filmes', where: 'id = ?', whereArgs: [id]);
  }
}
