// lib/middleware/auth_middleware.dart

import 'package:shelf/shelf.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import '../config/config.dart';

Middleware checkAuthMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      print('Requisição para: ${request.url.path}');
      print('Authorization: ${request.headers['Authorization']}');

      // Ignorar autenticação nas rotas login e cadastro
      if (request.url.path.startsWith('login') ||
          request.url.path.startsWith('cadastro')) {
        return await innerHandler(request);
      }

      final authHeader = request.headers['Authorization'];

      if (authHeader == null || !authHeader.startsWith('Bearer ')) {
        return Response(
          401,
          body: 'Token de autenticação não fornecido ou inválido',
          headers: {'Content-Type': 'application/json'},
        );
      }

      final token = authHeader.substring(7); // remove 'Bearer '

      try {
        final jwt = JWT.verify(token, SecretKey(jwtSecretKey));
        final updatedRequest = request.change(context: {'jwt': jwt.payload});
        return await innerHandler(updatedRequest);
      } catch (e) {
        print('Erro ao validar token JWT: $e');
        return Response(
          401,
          body: 'Token inválido ou expirado',
          headers: {'Content-Type': 'application/json'},
        );
      }
    };
  };
}
