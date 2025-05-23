//routes/casal.dart

import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:uuid/uuid.dart';
import 'package:projeto_backend/models/casal.dart';

final uuid = Uuid();

// Lista simples em memória para armazenar casais (substituir depois por banco)
final List<Casal> casais = [];

final Router casalRoutes =
    Router()
      // Criar vínculo de casal diretamente (pode ser usado para testes)
      ..post('/', (Request req) async {
        try {
          final body = await req.readAsString();
          final data = jsonDecode(body);

          final usuario1Id = data['usuario1Id'];
          final usuario2Id = data['usuario2Id'];

          if (usuario1Id == null || usuario2Id == null) {
            return Response(400, body: 'IDs dos usuários são obrigatórios');
          }

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
      })
      // Listar todos os casais (para testes)
      ..get('/', (Request req) {
        final listaCasaisJson = casais.map((c) => c.toJson()).toList();
        return Response.ok(
          jsonEncode({'casais': listaCasaisJson}),
          headers: {'Content-Type': 'application/json'},
        );
      });
