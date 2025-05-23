//models.usuario.dart

class Usuario {
  final String id;
  final String email;
  final String senha;

  Usuario({required this.id, required this.email, required this.senha});

  // Converte um objeto para Map (útil para JSON ou banco)
  Map<String, dynamic> toMap() {
    return {'id': id, 'email': email, 'senha': senha};
  }

  // Cria um objeto a partir de um Map (ex: vindo do JSON ou do banco)
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(id: map['id'], email: map['email'], senha: map['senha']);
  }
}
