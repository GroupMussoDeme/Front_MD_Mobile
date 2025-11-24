import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:musso_deme_app/services/contenu.dart';
import 'package:musso_deme_app/services/auth_service.dart';

class MediaApiService {
  MediaApiService._();

  static String get _baseUrl => AuthService.baseUrl; // ex: http://10.0.2.2:8080/api

  /// Récupère tous les contenus, puis filtre côté client
  static Future<List<Contenu>> fetchContenus({
    String? typeInfo,
    String? typeCategorie,
  }) async {
    final uri = Uri.parse('$_baseUrl/contenus/list');

    final headers = <String, String>{
      'Accept': 'application/json',
      // Si tu protèges /contenus/list, ajoute ici l'Authorization Bearer <token>
      // 'Authorization': 'Bearer $token',
    };

    final res = await http.get(uri, headers: headers);

    if (res.statusCode != 200) {
      throw Exception(
          'Erreur API (${res.statusCode}) : ${res.body.isNotEmpty ? res.body : 'réponse vide'}');
    }

    final List<dynamic> jsonList = jsonDecode(res.body);
    final all = jsonList.map((e) => Contenu.fromJson(e)).toList();

    return all.where((c) {
      final okTypeInfo =
          typeInfo == null || c.typeInfo.toUpperCase() == typeInfo.toUpperCase();
      final okCategorie = typeCategorie == null ||
          c.typeCategorie.toUpperCase() == typeCategorie.toUpperCase();
      return okTypeInfo && okCategorie;
    }).toList();
  }

  /// Construit l’URL HTTP complète pour un fichier (audio ou vidéo)
  /// "uploads\\1763_xxx.mp3" -> "http://10.0.2.2:8080/uploads/1763_xxx.mp3"
  static String fileUrl(String relativePath) {
    final normalized = relativePath.replaceAll('\\', '/');
    final root = _baseUrl.replaceFirst('/api', '');
    return '$root/$normalized';
  }
}
