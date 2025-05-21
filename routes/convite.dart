import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:uuid/uuid.dart';
import 'package:projeto_backend/models/convite_casal.dart';

final List<ConviteCasal> convites = [];
final uuid = Uuid();

final Router conviteRoutes =
    Router()..post('/', (Request request) async {
      try {
        // Pegando dados do token JWT (usuário logado)
        final jwt = request.context['jwt'] as Map<String, dynamic>?;
        if (jwt == null || jwt['id'] == null) {
          return Response.forbidden(jsonEncode({'error': 'Token inválido'}));
        }

        final usuarioRemetenteId = int.tryParse(jwt['id'].toString());
        if (usuarioRemetenteId == null) {
          return Response(
            400,
            body: jsonEncode({'error': 'ID do remetente inválido'}),
          );
        }

        // Lendo corpo da requisição
        final body = await request.readAsString();
        final data = jsonDecode(body);

        final usuarioDestinatarioId = int.tryParse(
          data['usuarioDestinatarioId'].toString(),
        );
        if (usuarioDestinatarioId == null) {
          return Response(
            400,
            body: jsonEncode({'error': 'ID do destinatário inválido'}),
          );
        }

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
    });
