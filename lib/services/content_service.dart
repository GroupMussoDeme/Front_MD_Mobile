import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import '../modeles/content_model.dart';

class ContentService {
  static const String _endpoint = '/admin/contenus';

  // En-têtes pour les requêtes avec authentification
  static Map<String, String> _getHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Créer un nouveau contenu
  static Future<ContentModel?> createContent(String token, ContentModel content) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}$_endpoint'),
        headers: _getHeaders(token),
        body: jsonEncode(content.toJsonForApi()),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return ContentModel.fromJson(data);
      } else {
        print('Erreur lors de la création du contenu: ${response.statusCode}');
        print('Message: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception lors de la création du contenu: $e');
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

  // Mettre à jour un contenu
  static Future<ContentModel?> updateContent(String token, ContentModel content) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiService.baseUrl}$_endpoint/${content.id}'),
        headers: _getHeaders(token),
        body: jsonEncode(content.toJsonForApi()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return ContentModel.fromJson(data);
      } else {
        print('Erreur lors de la mise à jour du contenu: ${response.statusCode}');
        print('Message: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception lors de la mise à jour du contenu: $e');
      return null;
    }
  }

  // Supprimer un contenu
  static Future<bool> deleteContent(String token, int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiService.baseUrl}$_endpoint/$id'),
        headers: _getHeaders(token),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Erreur lors de la suppression du contenu: ${response.statusCode}');
        print('Message: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception lors de la suppression du contenu: $e');
      return false;
    }
  }

  // Récupérer les contenus par type
  static Future<List<ContentModel>?> getContentsByType(String token, String type) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}$_endpoint/type/$type'),
        headers: _getHeaders(token),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ContentModel.fromJson(json)).toList();
      } else {
        print('Erreur lors de la récupération des contenus par type: ${response.statusCode}');
        print('Message: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception lors de la récupération des contenus par type: $e');
      return null;
    }
  }

  // Récupérer les contenus triés par date
  static Future<List<ContentModel>?> getContentsSortedByDate(String token, String order) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}$_endpoint/par-date?ordre=$order'),
        headers: _getHeaders(token),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ContentModel.fromJson(json)).toList();
      } else {
        print('Erreur lors de la récupération des contenus triés par date: ${response.statusCode}');
        print('Message: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception lors de la récupération des contenus triés par date: $e');
      return null;
    }
  }

  // Récupérer les contenus avec durée
  static Future<List<ContentModel>?> getContentsWithDuration(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}$_endpoint/avec-duree'),
        headers: _getHeaders(token),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ContentModel.fromJson(json)).toList();
      } else {
        print('Erreur lors de la récupération des contenus avec durée: ${response.statusCode}');
        print('Message: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception lors de la récupération des contenus avec durée: $e');
      return null;
    }
  }
}