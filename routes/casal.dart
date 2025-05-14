import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:uuid/uuid.dart';
import 'package:projeto_backend/models/casal.dart';

final uuid = Uuid();
final List<Casal> casais = [];

final Router casalRoutes =
    Router()..post('/', (Request req) async {
      try {
        final body = await req.readAsString();
        final data = jsonDecode(body);

        final usuario1Id = data['usuario1Id'];
        final usuario2Id = data['usuario2Id'];

        final novoCasal = Casal(
          id: uuid.v4(),
          usuario1Id: usuario1Id,
          usuario2Id: usuario2Id,
        );

        casais.add(novoCasal);

        return Response.ok(
          jsonEncode(novoCasal.toJson()),
          headers: {'Content-Type': 'application/json'},
        );
      } catch (e) {
        return Response.internalServerError(
          body: 'Erro ao criar casal: ${e.toString()}',
        );
      }
    });
