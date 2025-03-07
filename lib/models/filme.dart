class Filme {
  final int id;
  final String titulo;
  final int ano;
  final String diretor;
  final String resumo;
  final String urlCartaz;
  final double nota;

  Filme({
    required this.id,
    required this.titulo,
    required this.ano,
    required this.diretor,
    required this.resumo,
    required this.urlCartaz,
    required this.nota,
  });

  factory Filme.fromMap(Map<String, dynamic> map) {
    return Filme(
      id: map['id'],
      titulo: map['titulo'],
      ano: map['ano'],
      diretor: map['diretor'],
      resumo: map['resumo'],
      urlCartaz: map['url_cartaz'],
      nota: map['nota'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'ano': ano,
      'diretor': diretor,
      'resumo': resumo,
      'url_cartaz': urlCartaz,
      'nota': nota,
    };
  }
}