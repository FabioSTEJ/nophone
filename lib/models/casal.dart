class Casal {
  final String id;
  final String usuarioA;
  final String usuarioB;
  bool confirmado;

  Casal({
    required this.id,
    required this.usuarioA,
    required this.usuarioB,
    this.confirmado = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'usuarioA': usuarioA,
    'usuarioB': usuarioB,
    'confirmado': confirmado,
  };

  static Casal fromJson(Map<String, dynamic> json) {
    return Casal(
      id: json['id'],
      usuarioA: json['usuarioA'],
      usuarioB: json['usuarioB'],
      confirmado: json['confirmado'] ?? false,
    );
  }
}
