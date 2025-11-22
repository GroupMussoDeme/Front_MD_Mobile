import 'package:shared_preferences/shared_preferences.dart';


class SessionService {
  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyRole = 'role';
  static const _keyUserId = 'user_id';

  /// Sauvegarde la session après un login réussi
  static Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required String role,
    required int userId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccessToken, accessToken);
    await prefs.setString(_keyRefreshToken, refreshToken);
    await prefs.setString(_keyRole, role);
    await prefs.setInt(_keyUserId, userId);
  }

  /// Récupère les infos de session (ou null si rien)
  static Future<Map<String, dynamic>?> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString(_keyAccessToken);
    final refreshToken = prefs.getString(_keyRefreshToken);
    final role = prefs.getString(_keyRole);
    final userId = prefs.getInt(_keyUserId);

    if (accessToken == null || refreshToken == null || role == null || userId == null) {
      return null;
    }

    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'role': role,
      'userId': userId,
    };
  }

  /// Supprime toutes les infos de session (déconnexion)
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyRefreshToken);
    await prefs.remove(_keyRole);
    await prefs.remove(_keyUserId);
  }

  /// Raccourci pour récupérer seulement l’accessToken
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAccessToken);
  }

  /// Raccourci pour récupérer le refreshToken
  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRefreshToken);
  }
}
