import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.model.dart';

class AuthService {
  final String baseUrl = 'http://localhost:3000/api/user';
  final http.Client client;

  AuthService({required this.client});

  // Méthode pour l'inscription
  Future<String?> register(User user) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      );

      if (response.statusCode == 201) {
        return null; // Pas d'erreur
      } else {
        final error = json.decode(response.body)['error'] ?? 'Erreur inconnue';
        return error;
      }
    } catch (e) {
      return 'Erreur de connexion: $e';
    }
  }

  // Méthode pour la connexion
  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body); // Retourne {token, role, userId}
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}