// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

/// Config centralisée des URLs de ton backend
class ApiConfig {
  /// Base du backend (pour l'émulateur Android, localhost = 10.0.2.2)
  //static const String backendBase = 'http://10.0.2.2:8080';
  // Base du backend (pour telephone Android, localhost = 192.168.10.103)
   static const String backendBase = 'http://192.168.10.103:8080';

  /// Base des endpoints REST: /api/...
  static const String apiBase = '$backendBase/api';

  /// Base spécifique pour les endpoints Femme Rurale
  /// => http://10.0.2.2:8080/api/femmes-rurales
  static const String femmesRuralesBase = '$apiBase/femmes-rurales';
}

/// Service générique pour l'authentification et quelques appels simples
class ApiService {
  // On utilise la base "générale" /api
  static const String baseUrl = ApiConfig.apiBase;

  // En-têtes pour les requêtes JSON
  static final Map<String, String> jsonHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // ========================== AUTH ==========================

  // Méthode pour la connexion
  static Future<Map<String, dynamic>?> login(
    String identifiant,
    String motDePasse,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: jsonHeaders,
        body: jsonEncode({
          'identifiant': identifiant,
          'motDePasse': motDePasse,
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

  // Méthode pour l'inscription
  static Future<Map<String, dynamic>?> register({
    required String nom,
    required String prenom,
    required String numeroTel,
    required String localite,
    required String motCle,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: jsonHeaders,
        body: jsonEncode({
          'nom': nom,
          'prenom': prenom,
          'numeroTel': numeroTel,
          'localite': localite,
          'motCle': motCle,
        }),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        print('Erreur d\'inscription: ${response.statusCode}');
        print('Message: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception lors de l\'inscription: $e');
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

  // Méthode pour rafraîchir le token
  static Future<Map<String, dynamic>?> refreshToken(
    String refreshToken,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/refresh'),
        headers: jsonHeaders,
        body: jsonEncode({
          'refreshToken': refreshToken,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        print('Erreur de rafraîchissement du token: ${response.statusCode}');
        print('Message: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception lors du rafraîchissement du token: $e');
      return null;
    }
  }

  // ========================== EXEMPLES PRODUITS (ANCIEN) ==========================

  // Si tu ne les utilises plus, tu peux supprimer ces deux méthodes.
  static Future<List<dynamic>?> getProducts(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/femmes-rurales/produits'),
        headers: {
          'Authorization': 'Bearer $token',
          ...jsonHeaders,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data['data'] as List;
      } else {
        print(
            'Erreur lors de la récupération des produits: ${response.statusCode}');
        print('Message: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception lors de la récupération des produits: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> publishProduct({
    required String token,
    required int femmeId,
    required String nom,
    required String description,
    required double prix,
    required int quantite,
    required String typeProduit,
    String? image,
    String? audioGuideUrl,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/femmes-rurales/$femmeId/produits'),
        headers: {
          'Authorization': 'Bearer $token',
          ...jsonHeaders,
        },
        body: jsonEncode({
          'nom': nom,
          'description': description,
          'prix': prix,
          'quantite': quantite,
          'typeProduit': typeProduit,
          'image': image,
          'audioGuideUrl': audioGuideUrl,
        }),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data['data'] as Map<String, dynamic>;
      } else {
        print(
            'Erreur lors de la publication du produit: ${response.statusCode}');
        print('Message: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception lors de la publication du produit: $e');
      return null;
    }
  }
}
