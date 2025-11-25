import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import '../modeles/institution_model.dart';

class InstitutionService {
  static const String _endpoint = '/admin/institutions';

  // En-têtes pour les requêtes avec authentification
  static Map<String, String> _getHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Créer une nouvelle institution
  static Future<InstitutionModel?> createInstitution(String token, InstitutionModel institution) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}$_endpoint'),
        headers: _getHeaders(token),
        body: jsonEncode(institution.toJsonForApi()),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return InstitutionModel.fromJson(data);
      } else {
        print('Erreur lors de la création de l\'institution: ${response.statusCode}');
        print('Message: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception lors de la création de l\'institution: $e');
      return null;
    }
  }

  // Récupérer une institution par ID
  static Future<InstitutionModel?> getInstitutionById(String token, int id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}$_endpoint/$id'),
        headers: _getHeaders(token),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return InstitutionModel.fromJson(data);
      } else {
        print('Erreur lors de la récupération de l\'institution: ${response.statusCode}');
        print('Message: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception lors de la récupération de l\'institution: $e');
      return null;
    }
  }

  // Récupérer toutes les institutions
  static Future<List<InstitutionModel>?> getAllInstitutions(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}$_endpoint'),
        headers: _getHeaders(token),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => InstitutionModel.fromJson(json)).toList();
      } else {
        print('Erreur lors de la récupération des institutions: ${response.statusCode}');
        print('Message: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception lors de la récupération des institutions: $e');
      return null;
    }
  }

  // Mettre à jour une institution
  static Future<InstitutionModel?> updateInstitution(String token, InstitutionModel institution) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiService.baseUrl}$_endpoint/${institution.id}'),
        headers: _getHeaders(token),
        body: jsonEncode(institution.toJsonForApi()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return InstitutionModel.fromJson(data);
      } else {
        print('Erreur lors de la mise à jour de l\'institution: ${response.statusCode}');
        print('Message: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception lors de la mise à jour de l\'institution: $e');
      return null;
    }
  }

  // Supprimer une institution
  static Future<bool> deleteInstitution(String token, int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiService.baseUrl}$_endpoint/$id'),
        headers: _getHeaders(token),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Erreur lors de la suppression de l\'institution: ${response.statusCode}');
        print('Message: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception lors de la suppression de l\'institution: $e');
      return false;
    }
  }
}