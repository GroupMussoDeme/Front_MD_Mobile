import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import '../modeles/user_model.dart';

class UserProfileService {
  static const String _endpoint = '/profile';

  // En-têtes pour les requêtes avec authentification
  static Map<String, String> _getHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Récupérer le profil de l'utilisateur
  static Future<UserModel?> getUserProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}$_endpoint'),
        headers: _getHeaders(token),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return UserModel.fromJson(data);
      } else {
        print('Erreur lors de la récupération du profil utilisateur: ${response.statusCode}');
        print('Message: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception lors de la récupération du profil utilisateur: $e');
      return null;
    }
  }

  // Mettre à jour le profil de l'utilisateur
  static Future<UserModel?> updateUserProfile(String token, UserModel user) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiService.baseUrl}$_endpoint'),
        headers: _getHeaders(token),
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return UserModel.fromJson(data);
      } else {
        print('Erreur lors de la mise à jour du profil utilisateur: ${response.statusCode}');
        print('Message: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception lors de la mise à jour du profil utilisateur: $e');
      return null;
    }
  }

  // Changer le mot de passe de l'utilisateur
  static Future<bool> changePassword(String token, String oldPassword, String newPassword) async {
    try {
      final response = await http.patch(
        Uri.parse('${ApiService.baseUrl}$_endpoint/password'),
        headers: _getHeaders(token),
        body: jsonEncode({
          'ancienMotDePasse': oldPassword,
          'nouveauMotDePasse': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Erreur lors du changement de mot de passe: ${response.statusCode}');
        print('Message: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception lors du changement de mot de passe: $e');
      return false;
    }
  }
}