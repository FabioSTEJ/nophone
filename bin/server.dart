import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

// armazenamento do usuario
final List<Map<String, String>> usuarios = [];

void main() async {
  final router = Router();

  // rota
  router.get('/', (Request request) {
    return Response.ok('rota funcionando');
  });

  // cadastro
  router.post('/cadastro', (Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body);

    final email = data['email'];
    final senha = data['senha'];

    // verificação de usuario
    final jaExiste = usuarios.any((user) => user['email'] == email);
    if (jaExiste) {
      return Response(400, body: 'usuario ja existe');
    }

    usuarios.add({'email': email, 'senha': senha});
    return Response.ok('cadastrado');
  });

  // login
  router.post('/login', (Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body);

    final email = data['email'];
    final senha = data['senha'];

    final existe = usuarios.any(
      (user) => user['email'] == email && user['senha'] == senha,
    );

    if (existe) {
      return Response.ok('logado');
    } else {
      return Response(401, body: 'informações invalidas');
    }
  });

  // servidor
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(router);

  final server = await shelf_io.serve(handler, InternetAddress.anyIPv4, 8080);
  print('servidor http://${server.address.host}:${server.port}');
}
