//routes/convite.dart

import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:uuid/uuid.dart';
import 'package:projeto_backend/models/convite_casal.dart';

final List<ConviteCasal> convites = [];
final uuid = Uuid();

final Router conviteRoutes =
    Router()
      // POST / - Criar convite
      ..post('/', (Request request) async {
        try {
          // Verifica e extrai ID do usuário do token
          final jwt = request.context['jwt'] as Map<String, dynamic>?;
          if (jwt == null || jwt['id'] == null) {
            return Response.forbidden(jsonEncode({'error': 'Token inválido'}));
          }

          final String usuarioRemetenteId = jwt['id'].toString();

          // Lê e decodifica o corpo da requisição
          final body = await request.readAsString();
          final data = jsonDecode(body);

          final String usuarioDestinatarioId =
              data['usuarioDestinatarioId'].toString();

          final aniversarioNamoro =
              data['aniversarioNamoro'] != null
                  ? DateTime.tryParse(data['aniversarioNamoro'])
                  : null;

          final codigoConvite = uuid.v4().substring(0, 6);

          final novoConvite = ConviteCasal(
            id: uuid.v4(),
            usuarioRemetenteId: usuarioRemetenteId,
            usuarioDestinatarioId: usuarioDestinatarioId,
            codigoConvite: codigoConvite,
            dataCriacao: DateTime.now(),
            aniversarioNamoro: aniversarioNamoro,
          );

          convites.add(novoConvite);

          return Response.ok(
            jsonEncode({'convite': novoConvite.toJson()}),
            headers: {'Content-Type': 'application/json'},
          );
        } catch (e) {
          return Response.internalServerError(
            body: jsonEncode({'error': 'Erro ao criar convite: $e'}),
            headers: {'Content-Type': 'application/json'},
          );
        }
      })
      // GET /recebidos - Buscar convites recebidos pelo usuário logado
      ..get('/recebidos', (Request request) {
        try {
          final jwt = request.context['jwt'] as Map<String, dynamic>?;
          if (jwt == null || jwt['id'] == null) {
            return Response.forbidden(jsonEncode({'error': 'Token inválido'}));
          }

          final String usuarioLogadoId = jwt['id'].toString();

          final convitesRecebidos =
              convites
                  .where((c) => c.usuarioDestinatarioId == usuarioLogadoId)
                  .map((c) => c.toJson())
                  .toList();

          return Response.ok(
            jsonEncode({'convites': convitesRecebidos}),
            headers: {'Content-Type': 'application/json'},
          );
        } catch (e) {
          return Response.internalServerError(
            body: jsonEncode({'error': 'Erro ao buscar convites: $e'}),
            headers: {'Content-Type': 'application/json'},
          );
        }
      })
      ..put('/responder', (Request request) async {
        try {
          final jwt = request.context['jwt'] as Map<String, dynamic>?;
          if (jwt == null || jwt['id'] == null) {
            return Response.forbidden(jsonEncode({'error': 'Token inválido'}));
          }

          final String usuarioLogadoId = jwt['id'].toString();

          final body = await request.readAsString();
          final data = jsonDecode(body);

          final String conviteId = data['conviteId'];
          final String resposta = data['resposta'];

          final convite = convites.firstWhere(
            (c) => c.id == conviteId,
            orElse: () => throw Exception('Convite não encontrado'),
          );

          if (convite.usuarioDestinatarioId != usuarioLogadoId) {
            return Response.forbidden(
              jsonEncode({
                'error': 'Você não tem permissão para responder este convite',
              }),
            );
          }

          if (resposta != 'aceito' && resposta != 'recusado') {
            return Response(
              400,
              body: jsonEncode({
                'error': 'Resposta inválida: use "aceito" ou "recusado"',
              }),
            );
          }

          convite.status = resposta;

          return Response.ok(
            jsonEncode({'convite': convite.toJson()}),
            headers: {'Content-Type': 'application/json'},
          );
        } catch (e) {
          return Response.internalServerError(
            body: jsonEncode({'error': 'Erro ao responder convite: $e'}),
            headers: {'Content-Type': 'application/json'},
          );
        }
      });
