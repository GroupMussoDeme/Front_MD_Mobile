import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // L'URL de l'API Spring Boot
  static const String baseUrl = 'http://localhost:8080/api';
  
  // En-têtes pour les requêtes JSON
  static final Map<String, String> jsonHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Méthode pour la connexion
  static Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: jsonHeaders,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        print('Erreur de connexion: ${response.statusCode}');
        print('Message: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception lors de la connexion: $e');
      return null;
    }
  }

  // Méthode pour vérifier si l'utilisateur est authentifié
  static Future<bool> isAuthenticated(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/check'),
        headers: {
          'Authorization': 'Bearer $token',
          ...jsonHeaders,
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Exception lors de la vérification d\'authentification: $e');
      return false;
    }
  }
}