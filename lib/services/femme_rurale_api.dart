import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:musso_deme_app/models/marche_models.dart';
import 'package:musso_deme_app/services/session_service.dart';

class ApiConfig {
  static const String baseUrl = 'http://10.0.2.2:8080/api/femmes-rurales';
}

class FemmeRuraleApi {

  final http.Client _client;

  FemmeRuraleApi({http.Client? client}) : _client = client ?? http.Client();

  Future<String?> _accessToken() async => SessionService.getAccessToken();

  Future<int> _currentUserId() async {
    final session = await SessionService.loadSession();
    final userId = session?['userId'] as int?;
    if (userId == null) {
      throw Exception("Utilisateur non connecté");
    }
    return userId;
  }

  Future<Map<String, String>> _buildHeaders() async {
    final token = await SessionService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }


  // ================== UPLOAD IMAGE PRODUIT ==================

  /// Upload d’une image de produit vers le backend.
  /// Retourne le nom de fichier tel que sauvegardé côté serveur (ex: "34.jpg").
  Future<String> uploadProduitImage(File imageFile) async {
    final femmeId = await _currentUserId();

    // À adapter si ton endpoint est différent
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}/$femmeId/produits/upload-image',
    );

    final token = await _accessToken();
    final request = http.MultipartRequest('POST', uri);

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body);
      // On suppose que le backend renvoie { ..., "fileName": "34.jpg", ... }
      final fileName = decoded['fileName'] ?? decoded['data']?['fileName'];
      if (fileName == null) {
        throw Exception('Réponse upload image invalide : fileName manquant');
      }
      return fileName;
    } else {
      throw Exception(
        'Erreur upload image (${response.statusCode}) : ${response.body}',
      );
    }
  }

  // ================== PUBLIER PRODUIT ==================

 Future<Produit> publierProduit({required Produit produit}) async {
    final femmeId = await _currentUserId();
    final url = Uri.parse('${ApiConfig.baseUrl}/$femmeId/produits');

    final headers = await _buildHeaders();
    final body = jsonEncode(produit.toJson());

    debugPrint('POST $url');
    debugPrint('Headers: $headers');
    debugPrint('Body: $body');

    final response = await _client.post(url, headers: headers, body: body);

    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    if (response.statusCode == 201) {
      final decoded = jsonDecode(response.body);

      // D’après ton log backend : {"status":201,"message":"...","produit":{...},"timestamp":...}
      final produitJson = decoded['produit'] ?? decoded['data'] ?? decoded;

      return Produit.fromJson(produitJson);
    } else {
      throw Exception(
        'Erreur publication produit (${response.statusCode}) : ${response.body}',
      );
    }
  }


  // =========================================================
  //                     PRODUITS
  // =========================================================

  /// Tous les produits (toutes femmes)
  /// GET /api/femmes-rurales/produits
  Future<List<Produit>> getTousLesProduits() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/produits');
    final headers = await _buildHeaders();

    final response = await http.get(url, headers: headers);

    print('GET $url => ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      // On accepte soit "produits": [...], soit "data": [...]
      final List<dynamic> list =
          (decoded['produits'] ?? decoded['data'] ?? []) as List<dynamic>;

      return list
          .map((e) => Produit.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        'Erreur getTousLesProduits (${response.statusCode}) : ${response.body}',
      );
    }
  }

  /// Mes produits
  /// GET /api/femmes-rurales/{femmeId}/mes-produits
  Future<List<Produit>> getMesProduits() async {
    final femmeId = await _currentUserId();
    final url = Uri.parse('${ApiConfig.baseUrl}/$femmeId/mes-produits');
    final headers = await _buildHeaders();

    final response = await http.get(url, headers: headers);

    print('GET $url => ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      final List<dynamic> list =
          (decoded['produits'] ?? decoded['data'] ?? []) as List<dynamic>;

      return list
          .map((e) => Produit.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        'Erreur getMesProduits (${response.statusCode}) : ${response.body}',
      );
    }
  }

  /// Détail produit
  /// GET /api/femmes-rurales/produits/{produitId}
  Future<Produit> getProduitById(int produitId) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/produits/$produitId');
    final headers = await _buildHeaders();

    final response = await http.get(url, headers: headers);

    print('GET $url => ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      // on accepte soit "produit": {...}, soit "data": {...}
      final data = decoded['produit'] ?? decoded['data'];
      return Produit.fromJson(data as Map<String, dynamic>);
    } else {
      throw Exception(
        'Erreur getProduitById (${response.statusCode}) : ${response.body}',
      );
    }
  }

  /// Modification d'un produit
  /// PUT /api/femmes-rurales/{femmeId}/produits/{produitId}
  Future<Produit> modifierProduit({
    required int produitId,
    required Produit produit,
  }) async {
    final femmeId = await _currentUserId();
    final url = Uri.parse('${ApiConfig.baseUrl}/$femmeId/produits/$produitId');

    final headers = await _buildHeaders();

    final Map<String, dynamic> map = produit.toJson();
    map['femmeRuraleId'] = femmeId;
    map['quantite'] = map['quantite'] ?? 1;
    map['typeProduit'] = map['typeProduit'] ?? 'ALIMENTAIRE';

    final bodyJson = jsonEncode(map);

    print('PUT $url');
    print('Body: $bodyJson');

    final response = await http.put(url, headers: headers, body: bodyJson);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final data = decoded['produit'] ?? decoded['data'];

      return Produit.fromJson(data as Map<String, dynamic>);
    } else {
      throw Exception(
        'Erreur modification produit (${response.statusCode}) : ${response.body}',
      );
    }
  }

  /// Suppression d'un produit
  /// DELETE /api/femmes-rurales/{femmeId}/produits/{produitId}
  Future<void> supprimerProduit(int produitId) async {
    final femmeId = await _currentUserId();
    final url = Uri.parse('${ApiConfig.baseUrl}/$femmeId/produits/$produitId');

    final headers = await _buildHeaders();

    print('DELETE $url');

    final response = await http.delete(url, headers: headers);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception(
        'Erreur suppression produit (${response.statusCode}) : ${response.body}',
      );
    }
  }
  // ---------- COMMANDES ----------

  Future<Commande> passerCommande({
    required int produitId,
    required int quantite,
  }) async {
    final femmeId = await _currentUserId();
    final url = Uri.parse('${ApiConfig.baseUrl}/$femmeId/commandes').replace(
      queryParameters: {
        'produitId': produitId.toString(),
        'quantite': quantite.toString(),
      },
    );

    final headers = await _buildHeaders();
    final response = await http.post(url, headers: headers);

    if (response.statusCode == 201) {
      final decoded = jsonDecode(response.body);
      return Commande.fromJson(decoded['data']);
    } else {
      throw Exception('Erreur passage commande (${response.statusCode})');
    }
  }

  Future<List<Commande>> getMesCommandes() async {
    final femmeId = await _currentUserId();
    final url = Uri.parse('${ApiConfig.baseUrl}/$femmeId/mes-commandes');
    final headers = await _buildHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List<dynamic> data = decoded['data'] ?? [];
      return data.map((e) => Commande.fromJson(e)).toList();
    } else {
      throw Exception('Erreur récupération commandes (${response.statusCode})');
    }
  }

  // ---------- PAIEMENTS ----------

  Future<Paiement> payerCommande({
    required int commandeId,
    required double montant,
    required String modePaiement, // ORANGE_MONEY / MOOV_MONEY / ESPECE ...
  }) async {
    final femmeId = await _currentUserId();
    final url =
        Uri.parse(
          '${ApiConfig.baseUrl}/$femmeId/commandes/$commandeId/payer',
        ).replace(
          queryParameters: {
            'montant': montant.toString(),
            'modePaiement': modePaiement,
          },
        );

    final headers = await _buildHeaders();
    final response = await http.post(url, headers: headers);

    if (response.statusCode == 201) {
      final decoded = jsonDecode(response.body);
      return Paiement.fromJson(decoded['data']);
    } else {
      throw Exception('Erreur paiement commande (${response.statusCode})');
    }
  }

  // ---------- VENTES (vendeuse) ----------

  /// Nécessite côté backend : GET /api/femmes-rurales/{femmeId}/mes-ventes
  Future<List<Commande>> getMesVentes() async {
    final femmeId = await _currentUserId();
    final url = Uri.parse('${ApiConfig.baseUrl}/$femmeId/mes-ventes');
    final headers = await _buildHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List<dynamic> data = decoded['data'] ?? [];
      return data.map((e) => Commande.fromJson(e)).toList();
    } else {
      throw Exception('Erreur récupération ventes (${response.statusCode})');
    }
  }
}
