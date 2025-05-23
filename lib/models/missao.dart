//models/missao.dart

class Missao {
  final String id;
  final String titulo;
  final String descricao;
  final String categoria;
  final int dificuldade;
  final int pontosRecompensa;
  final String tipo;
  bool disponivel;

  Missao({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.categoria,
    required this.dificuldade,
    required this.pontosRecompensa,
    required this.tipo,
    this.disponivel = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'categoria': categoria,
      'dificuldade': dificuldade,
      'pontosRecompensa': pontosRecompensa,
      'tipo': tipo,
      'disponivel': disponivel,
    };
  }

  static Missao fromJson(Map<String, dynamic> json) {
    return Missao(
      id: json['id'],
      titulo: json['titulo'],
      descricao: json['descricao'],
      categoria: json['categoria'],
      dificuldade: json['dificuldade'],
      pontosRecompensa: json['pontosRecompensa'],
      tipo: json['tipo'],
      disponivel: json['disponivel'] ?? true,
    );
  }
}
