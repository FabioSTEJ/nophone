import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'cadastro.dart';

final loginRoutes =
    Router()..post('/', (Request req) async {
      final body = await req.readAsString(); // le a reqiusição

      try {
        final data = jsonDecode(body); //mapeia o json

        final email = data['email'];
        final senha = data['senha'];

        //verificação de validade dos campos
        if (email == null || senha == null) {
          return Response(400, body: 'preencha os campos');
        }

        //verificação do usuario
        final usuario = usuarios.firstWhere(
          (u) => u['email'] == email && u['senha'] == senha,
          orElse: () => {},
        );

        if (usuario.isEmpty) {
          return Response(401, body: 'verifique email e senha');
        }

        return Response.ok('logado');
      } catch (e) {
        return Response.internalServerError(
          body: 'erro no login: ${e.toString()}',
        );
      }
    });
