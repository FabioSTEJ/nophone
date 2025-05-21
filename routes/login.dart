// routes/login.dart
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:projeto_backend/models/usuario.dart';
import 'package:projeto_backend/database/database.dart'; // <== IMPORTAR AQUI
import 'package:collection/collection.dart';
import 'package:projeto_backend/config/config.dart';

final loginRoutes =
    Router()
      ..get('/', (Request req) {
        return Response.ok('Rota /login/ funcionando');
      })
      ..post('/', (Request req) async {
        final body = await req.readAsString();

        try {
          final data = jsonDecode(body);

          final email = data['email'] as String?;
          final senha = data['senha'] as String?;

          if (email == null || senha == null) {
            return Response(
              400,
              body: jsonEncode({'error': 'Email e senha são obrigatórios'}),
              headers: {'Content-Type': 'application/json'},
            );
          }

          final Usuario? usuario = usuarios.firstWhereOrNull(
            (u) => u.email == email,
          );

          if (usuario == null) {
            return Response(
              404,
              body: jsonEncode({'error': 'Usuário não encontrado'}),
              headers: {'Content-Type': 'application/json'},
            );
          }

          final senhaCorreta = BCrypt.checkpw(senha, usuario.senha);

          if (!senhaCorreta) {
            return Response(
              401,
              body: jsonEncode({'error': 'Senha incorreta'}),
              headers: {'Content-Type': 'application/json'},
            );
          }

          final jwt = JWT({'email': usuario.email, 'id': usuario.id});
          final token = jwt.sign(
            SecretKey(jwtSecretKey),
            expiresIn: const Duration(hours: 2),
          );

          return Response.ok(
            jsonEncode({'message': 'Login bem-sucedido', 'token': token}),
            headers: {'Content-Type': 'application/json'},
          );
        } catch (e) {
          return Response.internalServerError(
            body: jsonEncode({'error': 'Erro no login: ${e.toString()}'}),
            headers: {'Content-Type': 'application/json'},
          );
        }
      });
