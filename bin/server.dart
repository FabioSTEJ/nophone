import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

// rotas do software
import '../routes/cadastro.dart';
import '../routes/login.dart';

//gerenciador das rotas
void main() async {
  final app = Router();

  app.mount('/cadastro', cadastroRoutes);
  app.mount('/login', loginRoutes);

  final handler = const Pipeline().addMiddleware(logRequests()).addHandler(app);

  final server = await io.serve(handler, 'localhost', 8080);
  print('servidor online: http://${server.address.host}:${server.port}');
}
