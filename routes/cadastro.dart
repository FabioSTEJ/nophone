import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

// guardana memoria
final List<Map<String, String>> usuarios = [];

final cadastroRoutes =
    Router()..post('/', (Request req) async {
      final body = await req.readAsString(); //leitor da requisição

      try {
        final data = jsonDecode(body);

        final email = data['email'];
        final senha = data['senha'];

        // verificação do cadastro
        if (email == null || senha == null) {
          return Response(400, body: 'campos ausentes');
        }

        //validade de unicidade
        final usuarioExiste = usuarios.any((u) => u['email'] == email);

        if (usuarioExiste) {
          return Response(409, body: 'escolha outro usuario');
        }

        //adição do usuario
        usuarios.add({'email': email, 'senha': senha});
        return Response.ok('usuário cadastrado!');
      } catch (e) {
        return Response.internalServerError(
          body: 'Erro no cadastro: ${e.toString()}',
        );
      }
    });
