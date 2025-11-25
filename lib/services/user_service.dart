import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:musso_deme_app/models/user_model.dart';
import 'api_service.dart';

class UserService {
  // En-têtes pour les requêtes JSON avec authentification
  static Map<String, String> getAuthHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Récupérer tous les utilisateurs
  static Future<List<UserModel>?> getAllUsers(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/users'),
        headers: getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => UserModel.fromJson(json)).toList();
      } else {
        print('Erreur lors de la récupération des utilisateurs: ${response.statusCode}');
        print('Message: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception lors de la récupération des utilisateurs: $e');
      return null;
    }
  }

  // Récupérer un utilisateur par ID
  static Future<UserModel?> getUserById(String token, int id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/users/$id'),
        headers: getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return UserModel.fromJson(data);
      } else {
        print('Erreur lors de la récupération de l\'utilisateur: ${response.statusCode}');
        print('Message: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception lors de la récupération de l\'utilisateur: $e');
      return null;
    }
  }

  // Créer un nouvel utilisateur
  static Future<UserModel?> createUser(String token, UserModel user) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/users'),
        headers: getAuthHeaders(token),
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return UserModel.fromJson(data);
      } else {
        print('Erreur lors de la création de l\'utilisateur: ${response.statusCode}');
        print('Message: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception lors de la création de l\'utilisateur: $e');
      return null;
    }
  }

  // Mettre à jour un utilisateur
  static Future<UserModel?> updateUser(String token, UserModel user) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiService.baseUrl}/users/${user.id}'),
        headers: getAuthHeaders(token),
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return UserModel.fromJson(data);
      } else {
        print('Erreur lors de la mise à jour de l\'utilisateur: ${response.statusCode}');
        print('Message: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception lors de la mise à jour de l\'utilisateur: $e');
      return null;
    }
  }

  // Supprimer un utilisateur
  static Future<bool> deleteUser(String token, int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiService.baseUrl}/users/$id'),
        headers: getAuthHeaders(token),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        print('Erreur lors de la suppression de l\'utilisateur: ${response.statusCode}');
        print('Message: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception lors de la suppression de l\'utilisateur: $e');
      return false;
    }
  }
}