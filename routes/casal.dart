import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:uuid/uuid.dart';
import '../lib/models/casal.dart';

// Lista simulando um "banco de dados"
final List<Casal> casais = [];

final uuid = Uuid();

// Handler responsável por lidar com as requisições relacionadas ao casal
Handler casalRoutes = (Request req) async {
  // Verifica se é um POST para a rota base (já que foi montado em /criar-casal)
  if (req.method == 'POST' && req.url.path.isEmpty) {
    print('Recebido requisição POST para criar casal');

    try {
      final body = await req.readAsString();
      final data = jsonDecode(body);

      final usuarioA = data['usuarioA'];
      final usuarioB = data['usuarioB'];

      final novoCasal = Casal(
        id: uuid.v4(),
        usuarioA: usuarioA,
        usuarioB: usuarioB,
      );

      casais.add(novoCasal);

      return Response.ok(
        jsonEncode(novoCasal.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: 'Erro ao criar casal: ${e.toString()}',
        headers: {'Content-Type': 'text/plain'},
      );
    }
  }

  return Response.notFound('Rota não encontrada.');
};
