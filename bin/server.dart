// server.dart

import 'package:projeto_backend/middleware/auth_middleware.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

//

import '../routes/cadastro.dart';
import '../routes/login.dart';
import '../routes/casal.dart';
import '../routes/missao.dart';
import '../routes/missoes.dart';
import '../routes/convite.dart';

void main() async {
  // Rotas públicas
  final publicRouter =
      Router()
        ..mount('/cadastro/', cadastroRoutes.call)
        ..mount('/login/', loginRoutes.call)
        ..mount('/missoes/', missoesRoutes.call);

  // Rotas protegidas (com middleware)
  final privateRouter =
      Router()
        ..mount('/missao/', missaoRoutes.call)
        ..mount('/casal/', casalRoutes.call)
        ..mount('/convite/', conviteRoutes.call);

  // Pipeline com log
  final publicHandler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(publicRouter.call);

  final privateHandler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(checkAuthMiddleware())
      .addHandler(privateRouter.call);

  // Junta os dois com Cascade
  final handler = Cascade().add(publicHandler).add(privateHandler).handler;

  final server = await io.serve(handler, 'localhost', 8080);
  print('Servidor rodando em http://${server.address.host}:${server.port}');
}
