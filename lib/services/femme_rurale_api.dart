// lib/services/femme_rurale_api.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:musso_deme_app/services/api_service.dart';      // ApiConfig
import 'package:musso_deme_app/services/session_service.dart';  // SessionService
import 'package:musso_deme_app/models/marche_models.dart';      // Produit, Commande, Paiement

/// Service centralisé pour les API Femme Rurale (produits, commandes, ventes, paiements)
class FemmeRuraleApi {
  FemmeRuraleApi();

  /// Base URL pour les endpoints Femme Rurale
  /// => http://10.0.2.2:8080/api/femmes-rurales
  String get _baseUrl => ApiConfig.femmesRuralesBase;

  // =======================================================================
  // Helpers privés : session & headers
  // =======================================================================

  /// Récupère l'ID utilisateur courant depuis SessionService
  Future<int> _currentUserId() async {
    final session = await SessionService.loadSession();
    final userId = session?['userId'];
    if (userId == null) {
      throw Exception('Utilisateur non connecté (userId manquant en session)');
    }
    return userId as int;
  }

  /// Construit les headers HTTP, avec Authorization si token présent
  Future<Map<String, String>> _buildHeaders({bool withJson = true}) async {
    final accessToken = await SessionService.getAccessToken();

    final headers = <String, String>{};
    if (withJson) {
      headers['Content-Type'] = 'application/json';
    }
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }

    if (kDebugMode) {
      debugPrint('HTTP headers: $headers');
    }
    return headers;
  }

  /// Parse une liste de Produit depuis une réponse JSON
  List<Produit> _parseProduitsResponse(String body) {
    final decoded = jsonDecode(body);

    dynamic listJson;
    if (decoded is List) {
      listJson = decoded;
    } else if (decoded is Map) {
      listJson = decoded['data'] ?? decoded['produits'];
    }

    if (listJson is! List) return [];

    return listJson
        .map((e) => Produit.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Parse une liste de Commande depuis une réponse JSON
  List<Commande> _parseCommandesResponse(String body) {
    final decoded = jsonDecode(body);

    dynamic listJson;
    if (decoded is List) {
      listJson = decoded;
    } else if (decoded is Map) {
      listJson = decoded['data'] ?? decoded['commandes'];
    }

    if (listJson is! List) return [];

    return listJson
        .map((e) => Commande.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // =======================================================================
  // PRODUITS
  // =======================================================================

  /// Tous les produits (marché rural)
  Future<List<Produit>> getTousLesProduits() async {
    final url = Uri.parse('$_baseUrl/produits');
    final headers = await _buildHeaders(withJson: false);

    if (kDebugMode) debugPrint('GET $url');

    final response = await http.get(url, headers: headers);

    if (kDebugMode) {
      debugPrint('Response (${response.statusCode}): ${response.body}');
    }

    if (response.statusCode == 200) {
      return _parseProduitsResponse(response.body);
    } else {
      throw Exception(
        'Erreur getTousLesProduits (${response.statusCode}) : ${response.body}',
      );
    }
  }

  /// Mes produits (publiés par la femme connectée)
  Future<List<Produit>> getMesProduits() async {
    final femmeId = await _currentUserId();
    final url = Uri.parse('$_baseUrl/$femmeId/produits');
    final headers = await _buildHeaders(withJson: false);

    if (kDebugMode) debugPrint('GET $url');

    final response = await http.get(url, headers: headers);

    if (kDebugMode) {
      debugPrint('Response (${response.statusCode}): ${response.body}');
    }

    if (response.statusCode == 200) {
      return _parseProduitsResponse(response.body);
    } else {
      throw Exception(
        'Erreur getMesProduits (${response.statusCode}) : ${response.body}',
      );
    }
  }

  /// Publier un nouveau produit
  Future<Produit> publierProduit({
    required String nom,
    required String description,
    required double prix,
    required int quantite,
    required String typeProduit,    // ALIMENTAIRE, ARTISANAT, ...
    String? image,                  // nom de fichier (ex: "34.jpg")
    String? audioGuideUrl,
  }) async {
    final femmeId = await _currentUserId();
    final url = Uri.parse('$_baseUrl/$femmeId/produits');
    final headers = await _buildHeaders();

    final bodyMap = <String, dynamic>{
      'id': null,
      'nom': nom,
      'description': description,
      'prix': prix,
      'quantite': quantite,
      'typeProduit': typeProduit,
      'image': image,
      'audioGuideUrl': audioGuideUrl,
      'femmeRuraleId': femmeId,
    };

    if (kDebugMode) {
      debugPrint('POST $url');
      debugPrint('Headers: $headers');
      debugPrint('Body: ${jsonEncode(bodyMap)}');
    }

    final response =
        await http.post(url, headers: headers, body: jsonEncode(bodyMap));

    if (kDebugMode) {
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
    }

    if (response.statusCode == 201 || response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      final prodJson =
          decoded['produit'] ?? decoded['data'] ?? decoded as Map<String, dynamic>;

      return Produit.fromJson(prodJson as Map<String, dynamic>);
    } else {
      throw Exception(
        'Erreur publierProduit (${response.statusCode}) : ${response.body}',
      );
    }
  }

  /// Modifier un produit existant
  Future<Produit> modifierProduit({
    required int produitId,
    required String nom,
    required String description,
    required double prix,
    required int quantite,
    required String typeProduit,
    String? image,
    String? audioGuideUrl,
  }) async {
    final femmeId = await _currentUserId();
    final url = Uri.parse('$_baseUrl/$femmeId/produits/$produitId');
    final headers = await _buildHeaders();

    final bodyMap = <String, dynamic>{
      'id': produitId,
      'nom': nom,
      'description': description,
      'prix': prix,
      'quantite': quantite,
      'typeProduit': typeProduit,
      'image': image,
      'audioGuideUrl': audioGuideUrl,
      'femmeRuraleId': femmeId,
    };

    if (kDebugMode) {
      debugPrint('PUT $url');
      debugPrint('Headers: $headers');
      debugPrint('Body: ${jsonEncode(bodyMap)}');
    }

    final response =
        await http.put(url, headers: headers, body: jsonEncode(bodyMap));

    if (kDebugMode) {
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
    }

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final prodJson =
          decoded['produit'] ?? decoded['data'] ?? decoded as Map<String, dynamic>;
      return Produit.fromJson(prodJson as Map<String, dynamic>);
    } else {
      throw Exception(
        'Erreur modifierProduit (${response.statusCode}) : ${response.body}',
      );
    }
  }

  /// Supprimer un produit
  Future<void> supprimerProduit({required int produitId}) async {
    final femmeId = await _currentUserId();
    final url = Uri.parse('$_baseUrl/$femmeId/produits/$produitId');
    final headers = await _buildHeaders(withJson: false);

    if (kDebugMode) debugPrint('DELETE $url');

    final response = await http.delete(url, headers: headers);

    if (kDebugMode) {
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
    }

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        'Erreur supprimerProduit (${response.statusCode}) : ${response.body}',
      );
    }
  }

  // =======================================================================
  // COMMANDES & VENTES
  // =======================================================================

  /// Mes commandes (où je suis acheteur)
  Future<List<Commande>> getMesCommandes() async {
    final userId = await _currentUserId();
    final url = Uri.parse('$_baseUrl/$userId/commandes');
    final headers = await _buildHeaders(withJson: false);

    if (kDebugMode) debugPrint('GET $url');

    final response = await http.get(url, headers: headers);

    if (kDebugMode) {
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
    }

    if (response.statusCode == 200) {
      return _parseCommandesResponse(response.body);
    } else {
      throw Exception(
        'Erreur getMesCommandes (${response.statusCode}) : ${response.body}',
      );
    }
  }

  /// Mes ventes (commandes où je suis vendeuse)
  Future<List<Commande>> getMesVentes() async {
    final femmeId = await _currentUserId();
    final url = Uri.parse('$_baseUrl/$femmeId/ventes');
    final headers = await _buildHeaders(withJson: false);

    if (kDebugMode) debugPrint('GET $url');

    final response = await http.get(url, headers: headers);

    if (kDebugMode) {
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
    }

    if (response.statusCode == 200) {
      return _parseCommandesResponse(response.body);
    } else {
      throw Exception(
        'Erreur getMesVentes (${response.statusCode}) : ${response.body}',
      );
    }
  }

  /// Passer une commande pour un produit
  Future<Commande> passerCommande({
    required int produitId,
    required int quantite,
  }) async {
    final acheteurId = await _currentUserId();

    final url = Uri.parse(
      '$_baseUrl/$acheteurId/produits/$produitId/commandes',
    ).replace(
      queryParameters: {'quantite': quantite.toString()},
    );

    final headers = await _buildHeaders(withJson: false);

    if (kDebugMode) {
      debugPrint('POST $url');
      debugPrint('Headers: $headers');
    }

    final response = await http.post(url, headers: headers);

    if (kDebugMode) {
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
    }

    if (response.statusCode == 201 || response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final cmdJson =
          decoded['commande'] ?? decoded['data'] ?? decoded as Map<String, dynamic>;
      return Commande.fromJson(cmdJson as Map<String, dynamic>);
    } else {
      throw Exception(
        'Erreur passerCommande (${response.statusCode}) : ${response.body}',
      );
    }
  }

  /// Payer une commande
  Future<Paiement> payerCommande({
    required int commandeId,
    required double montant,
    required String modePaiement, // ORANGE_MONEY / MOOV_MONEY / ESPECE...
  }) async {
    final femmeId = await _currentUserId();

    final url = Uri.parse(
      '$_baseUrl/$femmeId/commandes/$commandeId/payer',
    ).replace(
      queryParameters: {
        'montant': montant.toString(),
        'modePaiement': modePaiement,
      },
    );

    final headers = await _buildHeaders(withJson: false);

    if (kDebugMode) {
      debugPrint('POST $url');
      debugPrint('Headers: $headers');
    }

    final response = await http.post(url, headers: headers);

    if (kDebugMode) {
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
    }

    if (response.statusCode == 201 || response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final payJson =
          decoded['data'] ?? decoded['paiement'] ?? decoded as Map<String, dynamic>;
      return Paiement.fromJson(payJson as Map<String, dynamic>);
    } else {
      throw Exception(
        'Erreur paiement commande (${response.statusCode}) : ${response.body}',
      );
    }
  }

  // =======================================================================
  // Upload d'image produit (multipart)
  // =======================================================================

  /// Upload d'image pour un produit.
  /// Endpoint backend attendu :
  /// POST /api/femmes-rurales/{femmeId}/produits/upload-image
  /// → renvoie { fileName: "34.jpg" } ou { image: "34.jpg" }
  Future<String> uploadProduitImage(File imageFile) async {
    final femmeId = await _currentUserId();
    final url = Uri.parse('$_baseUrl/$femmeId/produits/upload-image');

    final accessToken = await SessionService.getAccessToken();
    final request = http.MultipartRequest('POST', url);

    if (accessToken != null) {
      request.headers['Authorization'] = 'Bearer $accessToken';
    }

    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    if (kDebugMode) debugPrint('UPLOAD $url');

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (kDebugMode) {
      debugPrint('Upload status: ${response.statusCode}');
      debugPrint('Upload body: ${response.body}');
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body);
      final fileName = decoded['fileName'] ?? decoded['image'];
      if (fileName is String) {
        return fileName;
      }
      throw Exception('Réponse upload invalide: ${response.body}');
    } else {
      throw Exception(
        'Erreur upload image (${response.statusCode}) : ${response.body}',
      );
    }
  }
}
