import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import '../modeles/content_model.dart';

class ContentService {
  static const String _endpoint = '/contenus';

  // En-têtes pour les requêtes avec authentification
  static Map<String, String> _getHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Récupérer tous les contenus
  static Future<List<ContentModel>?> getAllContents(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}$_endpoint'),
        headers: _getHeaders(token),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ContentModel.fromJson(json)).toList();
      } else {
        print('Erreur lors de la récupération des contenus: ${response.statusCode}');
        print('Message: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception lors de la récupération des contenus: $e');
      return null;
    }
  }

  // Récupérer un contenu par ID
  static Future<ContentModel?> getContentById(String token, int id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}$_endpoint/$id'),
        headers: _getHeaders(token),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return ContentModel.fromJson(data);
      } else {
        print('Erreur lors de la récupération du contenu: ${response.statusCode}');
        print('Message: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception lors de la récupération du contenu: $e');
      return null;
    }
  }

  // Récupérer les contenus par catégorie
  static Future<List<ContentModel>?> getContentsByCategory(String token, int categoryId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}$_endpoint/categorie/$categoryId'),
        headers: _getHeaders(token),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ContentModel.fromJson(json)).toList();
      } else {
        print('Erreur lors de la récupération des contenus par catégorie: ${response.statusCode}');
        print('Message: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception lors de la récupération des contenus par catégorie: $e');
      return null;
    }
  }

  // Récupérer les contenus par langue
  static Future<List<ContentModel>?> getContentsByLanguage(String token, String language) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}$_endpoint/langue/$language'),
        headers: _getHeaders(token),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ContentModel.fromJson(json)).toList();
      } else {
        print('Erreur lors de la récupération des contenus par langue: ${response.statusCode}');
        print('Message: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception lors de la récupération des contenus par langue: $e');
      return null;
    }
  }
}