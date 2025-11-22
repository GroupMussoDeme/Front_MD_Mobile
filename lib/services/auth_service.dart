import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:musso_deme_app/services/session_service.dart';

class AuthService {
  AuthService._();

  // Même logique que tu avais
  static final String baseUrl = kIsWeb
      ? 'http://localhost:8080/api'
      : (Platform.isAndroid ? 'http://10.0.2.2:8080/api' : 'http://localhost:8080/api');

  static const Map<String, String> _baseHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Construit les headers, avec ou sans Authorization
  static Future<Map<String, String>> _buildHeaders({bool withAuth = false}) async {
    final headers = Map<String, String>.from(_baseHeaders);

    if (withAuth) {
      final token = await SessionService.getAccessToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  /// Méthode générique pour POST
  /// - withAuth : ajoute le Bearer token si true
  /// - autoRefresh : si true, tente un refresh du token en cas de 401
  static Future<Map<String, dynamic>> _post(
    String path, {
    required Map<String, dynamic> body,
    bool withAuth = false,
    bool autoRefresh = false,
  }) async {
    final uri = Uri.parse('$baseUrl$path');

    try {
      final headers = await _buildHeaders(withAuth: withAuth);
      final res = await http
          .post(uri, headers: headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 10));

      // Si requête protégée + 401, on tente un refresh puis un retry
      if (withAuth && autoRefresh && res.statusCode == 401) {
        return _tryRefreshAndRetry(path, body);
      }

      final payload =
          res.body.isNotEmpty ? jsonDecode(res.body) : <String, dynamic>{};

      return {'status': res.statusCode, 'data': payload};
    } catch (e) {
      return {
        'status': 500,
        'data': {'message': 'Erreur de connexion au serveur : $e'},
      };
    }
  }

  /// Tente un refresh + retry de la requête initiale
  static Future<Map<String, dynamic>> _tryRefreshAndRetry(
    String path,
    Map<String, dynamic> body,
  ) async {
    final storedRefresh = await SessionService.getRefreshToken();

    if (storedRefresh == null || storedRefresh.isEmpty) {
      await SessionService.clearSession();
      return {
        'status': 401,
        'data': {'message': 'Session expirée. Veuillez vous reconnecter.'},
      };
    }

    // 1) Appel du backend pour rafraîchir les tokens
    final refreshRes = await _post(
      '/auth/refresh/refresh',
      body: {'refreshToken': storedRefresh},
      withAuth: false,
      autoRefresh: false,
    );

    if (refreshRes['status'] == 200) {
      final data = refreshRes['data'];
      final newAccess = data['accessToken'] as String;
      final newRefresh = data['refreshToken'] as String;
      final role = data['role'] as String;
      final userId = data['userId'] as int;

      // 2) Sauvegarde des nouveaux tokens
      await SessionService.saveSession(
        accessToken: newAccess,
        refreshToken: newRefresh,
        role: role,
        userId: userId,
      );

      // 3) Retry de la requête initiale avec le nouveau AccessToken
      return _post(
        path,
        body: body,
        withAuth: true,
        autoRefresh: false, // IMPORTANT : pas de boucle infinie
      );
    } else {
      // Refresh impossible -> on considère la session comme expirée
      await SessionService.clearSession();
      return {
        'status': 401,
        'data': {'message': 'Session expirée. Veuillez vous reconnecter.'},
      };
    }
  }

  // -------------------------
  // API PUBLIQUE
  // -------------------------

  static Future<Map<String, dynamic>> registerUser({
    required String nom,
    required String prenom,
    required String telephone,
    required String localite,
    required String password,
  }) {
    return _post(
      '/auth/register',
      body: {
        'nom': nom.trim(),
        'prenom': prenom.trim(),
        'numeroTel': telephone.trim(),
        'localite': localite.trim(),
        'motCle': password.trim(),
      },
      withAuth: false,
      autoRefresh: false,
    );
  }

  static Future<Map<String, dynamic>> login({
    required String identifiant,
    required String motDePasse,
  }) {
    return _post(
      '/auth/login',
      body: {
        'identifiant': identifiant.trim(),
        'motDePasse': motDePasse.trim(),
      },
      withAuth: false,
      autoRefresh: false,
    );
  }

  /// Si tu veux appeler manuellement le refresh (optionnel maintenant)
  static Future<Map<String, dynamic>> refreshToken(String refreshToken) {
    return _post(
      '/auth/refresh/refresh',
      body: {'refreshToken': refreshToken},
      withAuth: false,
      autoRefresh: false,
    );
  }

  /// Exemple d’appel protégé (avec token + auto-refresh)
  static Future<Map<String, dynamic>> getProfilFemmeRurale() {
    return _post(
      '/femmes/profil',        // À adapter à ton vrai endpoint
      body: {},                // Si pas de body, garde {} ou adapte
      withAuth: true,          // Envoie Authorization: Bearer <token>
      autoRefresh: true,       // Gère automatiquement le 401
    );
  }
}
