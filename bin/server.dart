import 'package:projeto_backend/middleware/auth_middleware.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

//

import '../routes/cadastro.dart';
import '../routes/login.dart';
import '../routes/casal.dart';
import '../routes/missao.dart';

void main() async {
  final app = Router();

  // Monta as rotas
  app.mount('/cadastro/', cadastroRoutes);
  app.mount('/login/', loginRoutes);
  app.mount('/missao/', missaoRoutes);
  app.mount('/casal/', casalRoutes);

  // Chave secreta do JWT (pode colocar em config/env depois)
  const secretKey = 'segredo_super_secreto';

  // Middleware de autenticação com exceções para login e cadastro
  final authMiddleware = checkAuthMiddleware(secretKey);

  // Pipeline com logging e middleware de autenticação
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(authMiddleware)
      .addHandler(app.call);

  final server = await io.serve(handler, 'localhost', 8080);
  print('Servidor rodando em http://${server.address.host}:${server.port}');
}
