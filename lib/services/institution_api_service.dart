// lib/services/institution_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'institution.dart';

class InstitutionApiService {
  // Pour Android Emulator : 10.0.2.2:8080
  // Pour Flutter Web ou device réel : http://localhost:8080 ou IP de ta machine
  static const String _baseUrl = 'http://10.0.2.2:8080';

  static String get baseUrl => _baseUrl;

  static Future<List<InstitutionFinanciere>> fetchInstitutions() async {
    final uri = Uri.parse('$_baseUrl/api/institutions');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body) as List<dynamic>;
      return data
          .map((e) => InstitutionFinanciere.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
          'Erreur ${response.statusCode} lors du chargement des institutions');
    }
  }

  /// Construit une URL absolue à partir d’un chemin renvoyé par le backend
  static String fileUrl(String? relativePath) {
    if (relativePath == null || relativePath.isEmpty) {
      return '';
    }
    if (relativePath.startsWith('http://') ||
        relativePath.startsWith('https://')) {
      return relativePath;
    }
    // Exemple: "uploads/logos/kafo.png" -> http://10.0.2.2:8080/uploads/logos/kafo.png
    final normalized = relativePath.replaceAll('\\', '/');
    return '$_baseUrl/$normalized';
  }
}
