import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:uuid/uuid.dart';
import 'package:projeto_backend/models/missao.dart';

final List<Missao> missoes = [];
final uuid = Uuid();

final Router missaoRoutes =
    Router()
      ..post('/criar-missao', (Request req) async {
        try {
          final body = await req.readAsString();
          final data = jsonDecode(body);

          final titulo = data['titulo'];
          final descricao = data['descricao'];
          final categoria = data['categoria'];
          final dificuldade = data['dificuldade'];
          final pontosRecompensa = data['pontosRecompensa'];
          final tipo = data['tipo'];

          if ([
            titulo,
            descricao,
            categoria,
            dificuldade,
            pontosRecompensa,
            tipo,
          ].contains(null)) {
            return Response(400, body: 'Campos obrigatórios faltando');
          }

          final novaMissao = Missao(
            id: uuid.v4(),
            titulo: titulo,
            descricao: descricao,
            categoria: categoria,
            dificuldade: dificuldade,
            pontosRecompensa: pontosRecompensa,
            tipo: tipo,
          );

          missoes.add(novaMissao);

          return Response.ok(
            jsonEncode(novaMissao.toJson()),
            headers: {'Content-Type': 'application/json'},
          );
        } catch (e) {
          return Response.internalServerError(
            body: 'Erro ao criar missão: ${e.toString()}',
          );
        }
      })
      ..get('/', (Request req) {
        final lista = missoes.map((m) => m.toJson()).toList();
        return Response.ok(
          jsonEncode({'missoes': lista}),
          headers: {'Content-Type': 'application/json'},
        );
      });
