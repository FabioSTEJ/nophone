class Casal {
  final String id;
  final int usuario1Id;
  final int usuario2Id;
  final String? codigoConvite;

  Casal({
    required this.id,
    required this.usuario1Id,
    required this.usuario2Id,
    this.codigoConvite,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'usuario1_id': usuario1Id,
    'usuario2_id': usuario2Id,
    'codigo_convite': codigoConvite,
  };

  static Casal fromJson(Map<String, dynamic> json) {
    return Casal(
      id: json['id'],
      usuario1Id: json['usuario1_id'],
      usuario2Id: json['usuario2_id'],
      codigoConvite: json['codigo_convite'],
    );
  }
}
