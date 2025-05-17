// routes/cadastro.dart
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:projeto_backend/models/usuario.dart';
import 'package:projeto_backend/database/database.dart'; // <== IMPORTAR AQUI
import 'package:bcrypt/bcrypt.dart';

final cadastroRoutes =
    Router()..post('/', (Request req) async {
      final body = await req.readAsString();

      try {
        final data = jsonDecode(body);
        final email = data['email'];
        final senha = data['senha'];

        if (email == null || senha == null) {
          return Response(
            400,
            body: jsonEncode({'error': 'Campos ausentes'}),
            headers: {'Content-Type': 'application/json'},
          );
        }

        if (!_isEmailValido(email)) {
          return Response(
            400,
            body: jsonEncode({'error': 'Email inválido'}),
            headers: {'Content-Type': 'application/json'},
          );
        }

        if (senha.length < 6) {
          return Response(
            400,
            body: jsonEncode({'error': 'Senha muito curta'}),
            headers: {'Content-Type': 'application/json'},
          );
        }

        // Verifica se já existe
        final usuarioExiste = usuarios.any((u) => u.email == email);
        if (usuarioExiste) {
          return Response(
            409,
            body: jsonEncode({'error': 'Email já cadastrado'}),
            headers: {'Content-Type': 'application/json'},
          );
        }

        final senhaHash = BCrypt.hashpw(senha, BCrypt.gensalt());

        final novoUsuario = Usuario(
          id: 'simulado-id-uuid', // pode trocar depois por UUID real
          email: email,
          senha: senhaHash,
        );

        usuarios.add(novoUsuario);

        return Response.ok(
          jsonEncode({
            'message': 'Usuário cadastrado com sucesso!',
            'user': {'id': novoUsuario.id, 'email': novoUsuario.email},
          }),
          headers: {'Content-Type': 'application/json'},
        );
      } catch (e) {
        return Response.internalServerError(
          body: jsonEncode({'error': 'Erro no cadastro: ${e.toString()}'}),
          headers: {'Content-Type': 'application/json'},
        );
      }
    });

// Função para validar email
bool _isEmailValido(String email) {
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  return emailRegex.hasMatch(email);
}
