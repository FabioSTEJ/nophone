import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:projeto_backend/models/missao.dart';

final List<Missao> missoesPadrao = [
  Missao(
    id: '1',
    titulo: 'Caminhada juntos',
    descricao: 'Façam uma caminhada de pelo menos 30 minutos juntos.',
    categoria: 'bem_estar',
    dificuldade: 2,
    pontosRecompensa: 50,
    tipo: 'diaria',
  ),
  Missao(
    id: '2',
    titulo: 'Jantar especial',
    descricao: 'Preparem um jantar especial juntos em casa.',
    categoria: 'relacionamento',
    dificuldade: 3,
    pontosRecompensa: 100,
    tipo: 'semanal',
  ),
  Missao(
    id: '3',
    titulo: 'Organização',
    descricao: 'Organizem um cômodo da casa em dupla.',
    categoria: 'produtividade',
    dificuldade: 4,
    pontosRecompensa: 80,
    tipo: 'unica',
  ),
];

Future<Response> getMissoesHandler(Request request) async {
  final missoesJson = missoesPadrao.map((m) => m.toJson()).toList();
  return Response.ok(
    jsonEncode({'missoes': missoesJson}),
    headers: {'Content-Type': 'application/json'},
  );
}

final Router missoesRoutes = Router()..get('/', getMissoesHandler);
