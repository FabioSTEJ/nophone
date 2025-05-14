import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:uuid/uuid.dart';
import 'package:projeto_backend/models/missao.dart';

// Lista simulando o banco de dados
final List<Missao> missoes = [];
final uuid = Uuid();

Handler missaoRoutes = (Request req) async {
  if (req.method == 'POST' && req.url.path == 'criar-missao') {
    try {
      final body = await req.readAsString();
      final data = jsonDecode(body);

      final titulo = data['titulo'];
      final descricao = data['descricao'];
      final categoria = data['categoria'];
      final dificuldade = data['dificuldade'];
      final pontosRecompensa = data['pontosRecompensa'];
      final tipo = data['tipo'];

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
  }

  return Response.notFound('Missão não encontrada.');
};
