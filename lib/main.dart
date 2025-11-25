import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart'; //  l'import pour la lecture audio
import 'package:musso_deme_app/constants/assets.dart'; //  l'import pour les assets
import 'package:musso_deme_app/pages/ConfirmationScreen.dart';
import 'package:musso_deme_app/pages/HomeScreen.dart';
import 'package:musso_deme_app/pages/InscriptionScreen.dart';
import 'package:musso_deme_app/pages/LoginScreen.dart';
import 'package:musso_deme_app/pages/Demarrage.dart';
import 'package:musso_deme_app/pages/ValiderInscription.dart';
import 'package:musso_deme_app/pages/ValiderConnexion.dart';
import 'package:musso_deme_app/pages/ModernChatScreen.dart'; // Import de la nouvelle page de chat
import 'package:musso_deme_app/pages/AdminDashboardPage.dart'; // Import de la page admin
import 'package:musso_deme_app/services/user_preferences_service.dart'; // Import du service de préférences utilisateur

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialiser le service de préférences utilisateur
    UserPreferencesService.init();
    
    return MaterialApp(
      title: 'Musso Deme App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/Demarrage', // Démarrer sur la page Demarrage
      routes: {
        '/Demarrage': (context) => const Demarrage(), // Activer la route Demarrage
        // '/Connexion': (context) => LoginScreen(),
        // '/InscriptionScreen': (context) => InscriptionScreen(),
        // '/ConfirmationScreen': (context) => ConfirmationScreen(),
        '/HomeScreen': (context) => HomeScreen(),
        '/ValiderInscription': (context) => const ValiderInscription(),
        '/ValiderConnexion': (context) => const ValiderConnexion(),
        '/ModernChatScreen': (context) => const ModernChatScreen(), // Ajout de la nouvelle route
        '/AdminDashboard': (context) => const AdminDashboardPage(authToken: 'YOUR_AUTH_TOKEN_HERE'), // Route pour le tableau de bord admin
      },
    );
  }
}