// lib/services/femme_rurale_api.dart

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:musso_deme_app/models/marche_models.dart';

/// Client HTTP pour consommer les endpoints /api/femmes-rurales/... du backend.
class FemmeRuraleApi {
  /// Exemple : 'http://10.0.2.2:8080/api'
  final String baseUrl;

  /// Token JWT
  final String token;

  /// ID de la femme rurale connectée
  final int femmeId;

  FemmeRuraleApi({
    this.baseUrl = 'http://10.0.2.2:8080/api',
    required this.token,
    required this.femmeId,
  });

  Map<String, String> _authHeaders({Map<String, String>? extra}) {
    return {'Authorization': 'Bearer $token', ...?extra};
  }

  // =========================================================
  //                      PRODUITS
  // =========================================================

  /// Upload d'une image produit (Multipart, champ "image")
  /// --> POST /api/femmes-rurales/{femmeId}/produits/upload-image
  ///
  /// Retourne le nom du fichier (ex.: "prod_1_123456.jpg")
  Future<String> uploadProduitImage(File imageFile) async {
    final uri = Uri.parse(
      '$baseUrl/femmes-rurales/$femmeId/produits/upload-image',
    );

    final request = http.MultipartRequest('POST', uri);

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      // ne PAS mettre Content-Type ici
    });

    request.files.add(
      await http.MultipartFile.fromPath(
        'image', // doit matcher @RequestParam("image")
        imageFile.path,
        filename: imageFile.path.split('/').last,
      ),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      throw Exception(
        'Erreur upload image (${response.statusCode}) : ${response.body}',
      );
    }

    // Pour vérifier ce que renvoie le backend
    // print('UPLOAD RESPONSE BODY = ${response.body}');

    final Map<String, dynamic> jsonBody = jsonDecode(response.body);

    // ✅ maintenant le backend renvoie bien un champ "data"
    final data = jsonBody['data'] as Map<String, dynamic>?;
    final fileName = data?['fileName'] as String?;

    if (fileName == null || fileName.isEmpty) {
      throw Exception(
        'Réponse backend invalide : "fileName" manquant (body = ${response.body})',
      );
    }

    return fileName;
  }

  /// Publier un produit
  /// --> POST /api/femmes-rurales/{femmeId}/produits
  Future<Produit> publierProduit({
    required String nom,
    required String description,
    required double prix,
    required int quantite,
    required String typeProduit, // "ALIMENTAIRE" / "AGRICOLE" / "ARTISANAT"
    required String? image,
    String? audioGuideUrl,
    required String? unite, // ✅ nouvelle donnée
  }) async {
    final uri = Uri.parse('$baseUrl/femmes-rurales/$femmeId/produits');

    final body = {
      'nom': nom,
      'description': description,
      'prix': prix,
      'quantite': quantite,
      'typeProduit': typeProduit,
      'image': image,
      'audioGuideUrl': audioGuideUrl,
      'unite': unite, // ✅ doit matcher ProduitDTO.setUnite()
    };

    final response = await http.post(
      uri,
      headers: _authHeaders(extra: {'Content-Type': 'application/json'}),
      body: jsonEncode(body),
    );

    if (response.statusCode != 201) {
      throw Exception(
        'Erreur publication produit (${response.statusCode}) : ${response.body}',
      );
    }

    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    final Map<String, dynamic> produitJson =
        (jsonBody['data'] as Map<String, dynamic>);

    return Produit.fromJson(produitJson);
  }

  /// Modifier un produit
  /// --> PUT /api/femmes-rurales/{femmeId}/produits/{produitId}
  Future<Produit> modifierProduit({
    required int produitId,
    required String nom,
    required String description,
    required double prix,
    required int quantite,
    required String typeProduit,
    required String? image,
    String? audioGuideUrl,
    required String? unite, // ✅
  }) async {
    final uri = Uri.parse(
      '$baseUrl/femmes-rurales/$femmeId/produits/$produitId',
    );

    final body = {
      'id': produitId,
      'nom': nom,
      'description': description,
      'prix': prix,
      'quantite': quantite,
      'typeProduit': typeProduit,
      'image': image,
      'audioGuideUrl': audioGuideUrl,
      'unite': unite, // ✅
    };

    final response = await http.put(
      uri,
      headers: _authHeaders(extra: {'Content-Type': 'application/json'}),
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Erreur modification produit (${response.statusCode}) : ${response.body}',
      );
    }

    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    final Map<String, dynamic> produitJson =
        (jsonBody['data'] as Map<String, dynamic>);

    return Produit.fromJson(produitJson);
  }

  /// Supprimer un produit
  /// --> DELETE /api/femmes-rurales/{femmeId}/produits/{produitId}
  Future<void> supprimerProduit({required int produitId}) async {
    final uri = Uri.parse(
      '$baseUrl/femmes-rurales/$femmeId/produits/$produitId',
    );

    final response = await http.delete(uri, headers: _authHeaders());

    if (response.statusCode != 200) {
      throw Exception(
        'Erreur suppression produit (${response.statusCode}) : ${response.body}',
      );
    }
  }

  /// Récupérer les produits de la femme connectée
  /// --> GET /api/femmes-rurales/{femmeId}/mes-produits
  Future<List<Produit>> getMesProduits() async {
    final uri = Uri.parse('$baseUrl/femmes-rurales/$femmeId/mes-produits');

    final response = await http.get(uri, headers: _authHeaders());

    if (response.statusCode != 200) {
      throw Exception(
        'Erreur récupération mes produits (${response.statusCode}) : ${response.body}',
      );
    }

    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    final List<dynamic> dataList = jsonBody['data'] as List<dynamic>? ?? [];

    return dataList
        .map((e) => Produit.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Produit>> getTousLesProduits() async {
    final uri = Uri.parse('$baseUrl/femmes-rurales/produits');

    final response = await http.get(uri, headers: _authHeaders());

    if (response.statusCode != 200) {
      throw Exception(
        'Erreur récupération produits (${response.statusCode}) : ${response.body}',
      );
    }

    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    final List<dynamic> dataList = jsonBody['data'] as List<dynamic>? ?? [];

    // On parse les produits
    final produits = dataList
        .map((e) => Produit.fromJson(e as Map<String, dynamic>))
        .toList();

    // 🆕 On retire les produits de la femme connectée
    return produits
        .where((p) => p.femmeRuraleId == null || p.femmeRuraleId != femmeId)
        .toList();
  }

  /// Récupérer un produit par son id (avec éventuellement audio guide)
  /// --> GET /api/femmes-rurales/produits/{produitId}
  Future<Produit> getProduit(int produitId) async {
    final uri = Uri.parse('$baseUrl/femmes-rurales/produits/$produitId');

    final response = await http.get(uri, headers: _authHeaders());

    if (response.statusCode != 200) {
      throw Exception(
        'Erreur récupération produit (${response.statusCode}) : ${response.body}',
      );
    }

    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    final Map<String, dynamic> produitJson =
        (jsonBody['data'] as Map<String, dynamic>);

    return Produit.fromJson(produitJson);
  }

  /// Recherche de produits par type
  /// --> GET /api/femmes-rurales/produits/recherche/type/{typeProduit}
  Future<List<Produit>> rechercherProduitsParType(String typeProduit) async {
    final uri = Uri.parse(
      '$baseUrl/femmes-rurales/produits/recherche/type/$typeProduit',
    );

    final response = await http.get(uri, headers: _authHeaders());

    if (response.statusCode != 200) {
      throw Exception(
        'Erreur recherche produits par type (${response.statusCode}) : ${response.body}',
      );
    }

    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    final List<dynamic> dataList = jsonBody['data'] as List<dynamic>? ?? [];

    return dataList
        .map((e) => Produit.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Recherche de produits disponibles par type (quantité > 0)
  /// --> GET /api/femmes-rurales/produits/recherche/disponibles/type/{typeProduit}
  Future<List<Produit>> rechercherProduitsDisponiblesParType(
    String typeProduit,
  ) async {
    final uri = Uri.parse(
      '$baseUrl/femmes-rurales/produits/recherche/disponibles/type/$typeProduit',
    );

    final response = await http.get(uri, headers: _authHeaders());

    if (response.statusCode != 200) {
      throw Exception(
        'Erreur recherche produits disponibles par type (${response.statusCode}) : ${response.body}',
      );
    }

    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    final List<dynamic> dataList = jsonBody['data'] as List<dynamic>? ?? [];

    return dataList
        .map((e) => Produit.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Recherche de produits par nom (contient, ignore case)
  /// --> GET /api/femmes-rurales/produits/recherche/nom/{nom}
  Future<List<Produit>> rechercherProduitsParNom(String nom) async {
    final uri = Uri.parse(
      '$baseUrl/femmes-rurales/produits/recherche/nom/$nom',
    );

    final response = await http.get(uri, headers: _authHeaders());

    if (response.statusCode != 200) {
      throw Exception(
        'Erreur recherche produits par nom (${response.statusCode}) : ${response.body}',
      );
    }

    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    final List<dynamic> dataList = jsonBody['data'] as List<dynamic>? ?? [];

    return dataList
        .map((e) => Produit.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // =========================================================
  //                      COMMANDES
  // =========================================================

  /// Passer une commande sur un produit donné
  /// --> POST /api/femmes-rurales/{femmeId}/commandes
  /// @RequestParam Long produitId, @RequestParam Integer quantite
  Future<Commande> passerCommande({
    required int produitId,
    required int quantite,
  }) async {
    final uri = Uri.parse('$baseUrl/femmes-rurales/$femmeId/commandes');

    final response = await http.post(
      uri,
      headers: _authHeaders(
        extra: {'Content-Type': 'application/x-www-form-urlencoded'},
      ),
      body: {
        'produitId': produitId.toString(),
        'quantite': quantite.toString(),
      },
    );

    if (response.statusCode != 201) {
      // 🆕 utilise le helper pour récupérer le message fonctionnel
      throw _buildApiException('Erreur passage commande', response);
    }

    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    final Map<String, dynamic> commandeJson =
        (jsonBody['data'] as Map<String, dynamic>);

    return Commande.fromJson(commandeJson);
  }

  /// Récupérer toutes mes ventes (commandes où je suis vendeuse)
  /// --> GET /api/femmes-rurales/{femmeId}/mes-ventes
  Future<List<Commande>> getMesVentes() async {
    final uri = Uri.parse('$baseUrl/femmes-rurales/$femmeId/mes-ventes');

    final response = await http.get(uri, headers: _authHeaders());

    if (response.statusCode != 200) {
      throw Exception(
        'Erreur récupération mes ventes (${response.statusCode}) : ${response.body}',
      );
    }

    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    final List<dynamic> dataList = jsonBody['data'] as List<dynamic>? ?? [];

    return dataList
        .map((e) => Commande.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Payer une commande
  /// --> POST /api/femmes-rurales/{femmeId}/commandes/{commandeId}/payer
  /// @RequestParam Double montant, @RequestParam ModePaiement modePaiement
  ///
  /// modePaiement doit être une valeur string de l'enum backend :
  /// "ORANGE_MONEY", "MOOV_MONEY", "ESPECE", etc.
  Future<Paiement> payerCommande({
    required int commandeId,
    required double montant,
    required String modePaiement,
  }) async {
    final uri = Uri.parse(
      '$baseUrl/femmes-rurales/$femmeId/commandes/$commandeId/payer',
    );

    final response = await http.post(
      uri,
      headers: _authHeaders(
        extra: {'Content-Type': 'application/x-www-form-urlencoded'},
      ),
      body: {'montant': montant.toString(), 'modePaiement': modePaiement},
    );

    if (response.statusCode != 201) {
      // 🆕 remonte le message métier (montant incorrect, commande déjà payée, etc.)
      throw _buildApiException('Erreur paiement commande', response);
    }

    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    final Map<String, dynamic> paiementJson =
        (jsonBody['data'] as Map<String, dynamic>);

    return Paiement.fromJson(paiementJson);
  }

  /// Récupérer toutes mes commandes (en tant qu'acheteuse + vendeuse)
  /// --> GET /api/femmes-rurales/{femmeId}/mes-commandes
  Future<List<Commande>> getMesCommandes() async {
    final uri = Uri.parse('$baseUrl/femmes-rurales/$femmeId/mes-commandes');

    final response = await http.get(uri, headers: _authHeaders());

    if (response.statusCode != 200) {
      throw Exception(
        'Erreur récupération mes commandes (${response.statusCode}) : ${response.body}',
      );
    }

    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    final List<dynamic> dataList = jsonBody['data'] as List<dynamic>? ?? [];

    return dataList
        .map((e) => Commande.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // =========================================================
  //                      PAIEMENTS (lecture)
  // =========================================================
  //
  // Pour l'instant, ton controller ne publie pas d'endpoint
  // GET /paiements pour la femme. Si tu en ajoutes un côté backend,
  // on pourra compléter ici une méthode getMesPaiements().

  // =========================================================
  //                  COOPERATIVES & APPARTENANCES
  // =========================================================

  /// Créer une coopérative
  /// POST /api/femmes-rurales/{femmeId}/cooperatives
  Future<Cooperative> creerCooperative({
    required String nom,
    String? description,
  }) async {
    final uri = Uri.parse('$baseUrl/femmes-rurales/$femmeId/cooperatives');

    final body = <String, String>{
      'nom': nom,
      if (description != null && description.isNotEmpty)
        'description': description,
    };

    final response = await http.post(
      uri,
      headers: _authHeaders(
        extra: {'Content-Type': 'application/x-www-form-urlencoded'},
      ),
      body: body,
    );

    if (response.statusCode != 201) {
      throw _buildApiException('Erreur création coopérative', response);
    }

    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    final Map<String, dynamic> coopJson =
        jsonBody['data'] as Map<String, dynamic>;

    return Cooperative.fromJson(coopJson);
  }

  /// Rejoindre une coopérative
  /// POST /api/femmes-rurales/{femmeId}/cooperatives/{cooperativeId}/joindre
  Future<Appartenance> joindreCooperative({required int cooperativeId}) async {
    final uri = Uri.parse(
      '$baseUrl/femmes-rurales/$femmeId/cooperatives/$cooperativeId/joindre',
    );

    final response = await http.post(uri, headers: _authHeaders());

    if (response.statusCode != 201) {
      throw _buildApiException('Erreur rejoindre coopérative', response);
    }

    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    final Map<String, dynamic> appartJson =
        jsonBody['data'] as Map<String, dynamic>;

    return Appartenance.fromJson(appartJson);
  }

  /// =========================================================
  ///                 COOPERATIVES (lecture)
  /// =========================================================

  /// Récupérer les coopératives dont je suis membre
  /// --> GET /api/femmes-rurales/{femmeId}/mes-cooperatives
  Future<List<Cooperative>> getMesCooperatives() async {
    final uri = Uri.parse('$baseUrl/femmes-rurales/$femmeId/mes-cooperatives');

    final response = await http.get(uri, headers: _authHeaders());

    if (response.statusCode != 200) {
      throw Exception(
        'Erreur récupération mes coopératives (${response.statusCode}) : ${response.body}',
      );
    }

    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    final List<dynamic> dataList = jsonBody['data'] as List<dynamic>? ?? [];

    return dataList
        .map((e) => Cooperative.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // =========================================================
  //                  CHAT VOCAL - COOPERATIVES
  // =========================================================

  /// Récupérer les messages vocaux d'une coopérative
  /// GET /api/femmes-rurales/cooperatives/{cooperativeId}/messages
  Future<List<ChatVocal>> getMessagesCooperative({
    required int cooperativeId,
  }) async {
    final uri = Uri.parse(
      '$baseUrl/femmes-rurales/cooperatives/$cooperativeId/messages',
    );

    final response = await http.get(uri, headers: _authHeaders());

    if (response.statusCode != 200) {
      throw _buildApiException(
        'Erreur récupération messages coopérative',
        response,
      );
    }

    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    final List<dynamic> dataList = jsonBody['data'] as List<dynamic>? ?? [];

    return dataList
        .map((e) => ChatVocal.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // =========================================================
  //                  CHAT VOCAL - PRIVE
  // =========================================================

  /// Envoyer un message vocal privé
  /// POST /api/femmes-rurales/{expediteurId}/chats/envoyer
  Future<ChatVocal> envoyerMessagePrive({
    required int destinataireId,
    required String audioUrl,
  }) async {
    final uri = Uri.parse('$baseUrl/femmes-rurales/$femmeId/chats/envoyer');

    final response = await http.post(
      uri,
      headers: _authHeaders(
        extra: {'Content-Type': 'application/x-www-form-urlencoded'},
      ),
      body: {'destinataireId': destinataireId.toString(), 'audioUrl': audioUrl},
    );

    if (response.statusCode != 201) {
      throw _buildApiException('Erreur envoi message privé', response);
    }

    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    final Map<String, dynamic> msgJson =
        jsonBody['data'] as Map<String, dynamic>;

    return ChatVocal.fromJson(msgJson);
  }

  /// Récupérer l'historique de chat vocal entre la femme connectée et une autre
  /// GET /api/femmes-rurales/{femme1Id}/chats/{femme2Id}
  Future<List<ChatVocal>> getHistoriqueChatVocal({
    required int autreFemmeId,
  }) async {
    final uri = Uri.parse(
      '$baseUrl/femmes-rurales/$femmeId/chats/$autreFemmeId',
    );

    final response = await http.get(uri, headers: _authHeaders());

    if (response.statusCode != 200) {
      throw _buildApiException(
        'Erreur récupération historique chat vocal',
        response,
      );
    }

    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    final List<dynamic> dataList = jsonBody['data'] as List<dynamic>? ?? [];

    return dataList
        .map((e) => ChatVocal.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Marquer un message vocal comme lu
  /// PUT /api/femmes-rurales/chats/{messageId}/lu
  Future<void> marquerMessageCommeLu({required int messageId}) async {
    final uri = Uri.parse('$baseUrl/femmes-rurales/chats/$messageId/lu');

    final response = await http.put(uri, headers: _authHeaders());

    if (response.statusCode != 200) {
      throw _buildApiException('Erreur marquage message comme lu', response);
    }
    // le backend ne renvoie pas de data spécifique, juste un message
  }

  // =========================================================
  //           COOPERATIVES : UPLOAD AUDIO + MESSAGES
  // =========================================================

  /// Upload d'un audio pour une coopérative
  /// --> POST /api/femmes-rurales/{femmeId}/cooperatives/{cooperativeId}/audios
  /// form-data: file = <audio>
  ///
  /// Retourne l'URL relative renvoyée par le backend (ex: "/uploads/audios/xxx.aac")
  Future<String> uploadCoopAudio({
    required int cooperativeId,
    required String filePath,
  }) async {
    final uri = Uri.parse(
      '$baseUrl/femmes-rurales/$femmeId/cooperatives/$cooperativeId/audios',
    );

    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(await http.MultipartFile.fromPath('file', filePath));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 201) {
      throw _buildApiException('Erreur upload audio coopérative', response);
    }

    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    // data contient directement l'URL relative
    final audioUrl = jsonBody['data'] as String?;
    if (audioUrl == null || audioUrl.isEmpty) {
      throw Exception(
        'Réponse backend invalide : "data" manquant (body = ${response.body})',
      );
    }
    return audioUrl;
  }

  /// Envoyer un message vocal dans une coopérative
  /// --> POST /api/femmes-rurales/{femmeId}/cooperatives/{cooperativeId}/messages
  /// @RequestParam String audioUrl
  Future<ChatVocal> envoyerMessageCooperative({
    required int cooperativeId,
    required String audioUrl,
  }) async {
    final uri = Uri.parse(
      '$baseUrl/femmes-rurales/$femmeId/cooperatives/$cooperativeId/messages',
    );

    final response = await http.post(
      uri,
      headers: _authHeaders(
        extra: {'Content-Type': 'application/x-www-form-urlencoded'},
      ),
      body: {'audioUrl': audioUrl},
    );

    if (response.statusCode != 201) {
      throw _buildApiException('Erreur envoi message coopérative', response);
    }

    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    final Map<String, dynamic> msgJson =
        jsonBody['data'] as Map<String, dynamic>;

    return ChatVocal.fromJson(msgJson);
  }

  /// Envoyer un message TEXTE dans une coopérative
  /// POST /api/femmes-rurales/{femmeId}/cooperatives/{cooperativeId}/messages-textes
  Future<ChatVocal> envoyerMessageTexteCooperative({
    required int cooperativeId,
    required String texte,
  }) async {
    final uri = Uri.parse(
      '$baseUrl/femmes-rurales/$femmeId/cooperatives/$cooperativeId/messages-textes',
    );

    final response = await http.post(
      uri,
      headers: _authHeaders(
        extra: {'Content-Type': 'application/x-www-form-urlencoded'},
      ),
      body: {'texte': texte},
    );

    if (response.statusCode != 201) {
      throw _buildApiException(
        'Erreur envoi message texte coopérative',
        response,
      );
    }

    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    final Map<String, dynamic> msgJson =
        jsonBody['data'] as Map<String, dynamic>;

    return ChatVocal.fromJson(msgJson);
  }
}

// =========================================================
//                  UTILITAIRE ERREUR API
// =========================================================

Exception _buildApiException(String prefix, http.Response response) {
  try {
    final Map<String, dynamic> body = jsonDecode(response.body);
    final message = body['message'] as String?;
    if (message != null && message.isNotEmpty) {
      // On renvoie uniquement le message fonctionnel
      return Exception(message);
    }
  } catch (_) {
    // si le body n'est pas du JSON ou n'a pas 'message'
  }

  // Fallback : message générique
  return Exception('$prefix (${response.statusCode}) : ${response.body}');
}
