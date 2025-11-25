import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import '../modeles/user_model.dart';

class AdminProfileService {
  static const String _endpoint = '/admin/profile';

  // En-têtes pour les requêtes avec authentification
  static Map<String, String> _getHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Récupérer le profil d'un admin par son ID
  static Future<UserModel?> getAdminProfileById(String token, int id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}$_endpoint/$id'),
        headers: _getHeaders(token),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return UserModel.fromJson(data);
      } else {
        print('Erreur lors de la récupération du profil admin: ${response.statusCode}');
        print('Message: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception lors de la récupération du profil admin: $e');
      return null;
    }
  }

  // Récupérer le profil d'un admin par son email
  static Future<UserModel?> getAdminProfileByEmail(String token, String email) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}$_endpoint/email/$email'),
        headers: _getHeaders(token),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return UserModel.fromJson(data);
      } else {
        print('Erreur lors de la récupération du profil admin par email: ${response.statusCode}');
        print('Message: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception lors de la récupération du profil admin par email: $e');
      return null;
    }
  }

  // Mettre à jour le profil d'un admin
  static Future<UserModel?> updateAdminProfile(String token, int id, Map<String, dynamic> updates) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiService.baseUrl}$_endpoint/$id'),
        headers: _getHeaders(token),
        body: jsonEncode(updates),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return UserModel.fromJson(data);
      } else {
        print('Erreur lors de la mise à jour du profil admin: ${response.statusCode}');
        print('Message: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception lors de la mise à jour du profil admin: $e');
      return null;
    }
  }

  // Désactiver un compte admin
  static Future<bool> deactivateAdminAccount(String token, int id) async {
    try {
      final response = await http.patch(
        Uri.parse('${ApiService.baseUrl}$_endpoint/$id/deactivate'),
        headers: _getHeaders(token),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Erreur lors de la désactivation du compte admin: ${response.statusCode}');
        print('Message: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception lors de la désactivation du compte admin: $e');
      return false;
    }
  }

  // Activer un compte admin
  static Future<bool> activateAdminAccount(String token, int id) async {
    try {
      final response = await http.patch(
        Uri.parse('${ApiService.baseUrl}$_endpoint/$id/activate'),
        headers: _getHeaders(token),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Erreur lors de l\'activation du compte admin: ${response.statusCode}');
        print('Message: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception lors de l\'activation du compte admin: $e');
      return false;
    }
  }

  // Supprimer définitivement un compte admin
  static Future<bool> deleteAdminAccount(String token, int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiService.baseUrl}$_endpoint/$id'),
        headers: _getHeaders(token),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Erreur lors de la suppression du compte admin: ${response.statusCode}');
        print('Message: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception lors de la suppression du compte admin: $e');
      return false;
    }
  }
}