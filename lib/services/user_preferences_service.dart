import 'package:shared_preferences/shared_preferences.dart';

class UserPreferencesService {
  static const String _userFirstNameKey = 'user_first_name';
  static const String _userLastNameKey = 'user_last_name';
  
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Sauvegarder le prénom de l'utilisateur
  static Future<bool> saveUserFirstName(String firstName) async {
    if (_prefs == null) await init();
    return _prefs!.setString(_userFirstNameKey, firstName);
  }

  // Sauvegarder le nom de l'utilisateur
  static Future<bool> saveUserLastName(String lastName) async {
    if (_prefs == null) await init();
    return _prefs!.setString(_userLastNameKey, lastName);
  }

  // Récupérer le prénom de l'utilisateur
  static String getUserFirstName() {
    if (_prefs == null) return 'Aminata';
    return _prefs!.getString(_userFirstNameKey) ?? 'Aminata';
  }

  // Récupérer le nom de l'utilisateur
  static String getUserLastName() {
    if (_prefs == null) return '';
    return _prefs!.getString(_userLastNameKey) ?? '';
  }

  // Récupérer le nom complet de l'utilisateur
  static String getUserFullName() {
    final firstName = getUserFirstName();
    final lastName = getUserLastName();
    
    if (lastName.isNotEmpty) {
      return '$firstName $lastName';
    }
    return firstName;
  }

  // Effacer toutes les préférences utilisateur
  static Future<bool> clearUserPreferences() async {
    if (_prefs == null) await init();
    final result1 = await _prefs!.remove(_userFirstNameKey);
    final result2 = await _prefs!.remove(_userLastNameKey);
    return result1 && result2;
  }
}