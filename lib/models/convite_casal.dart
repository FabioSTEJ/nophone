// models/convite_casal.dart

class ConviteCasal {
  final String id;
  final String usuarioRemetenteId;
  final String usuarioDestinatarioId;
  final String codigoConvite;
  String status; // 'pendente', 'aceito', 'recusado'
  final DateTime dataCriacao;
  final DateTime? aniversarioNamoro; // Opcional

  ConviteCasal({
    required this.id,
    required this.usuarioRemetenteId,
    required this.usuarioDestinatarioId,
    required this.codigoConvite,
    this.status = 'pendente',
    required this.dataCriacao,
    this.aniversarioNamoro,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuarioRemetenteId': usuarioRemetenteId,
      'usuarioDestinatarioId': usuarioDestinatarioId,
      'codigoConvite': codigoConvite,
      'status': status,
      'dataCriacao': dataCriacao.toIso8601String(),
      'aniversarioNamoro': aniversarioNamoro?.toIso8601String(),
    };
  }

  static ConviteCasal fromJson(Map<String, dynamic> json) {
    return ConviteCasal(
      id: json['id'],
      usuarioRemetenteId: json['usuarioRemetenteId'],
      usuarioDestinatarioId: json['usuarioDestinatarioId'],
      codigoConvite: json['codigoConvite'],
      status: json['status'] ?? 'pendente',
      dataCriacao: DateTime.parse(json['dataCriacao']),
      aniversarioNamoro:
          json['aniversarioNamoro'] != null
              ? DateTime.parse(json['aniversarioNamoro'])
              : null,
    );
  }
}
