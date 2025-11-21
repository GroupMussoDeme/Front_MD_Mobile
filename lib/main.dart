import 'package:flutter/material.dart';
import 'package:musso_deme_app/pages/ConfirmationScreen.dart';
import 'package:musso_deme_app/pages/HomeScreen.dart';
import 'package:musso_deme_app/pages/InscriptionScreen.dart';
import 'package:musso_deme_app/pages/LoginScreen.dart';
import 'package:musso_deme_app/pages/Demarrage.dart';
import 'package:musso_deme_app/pages/ValiderInscription.dart';
import 'package:musso_deme_app/pages/ValiderConnexion.dart'; // Import de la nouvelle page
import 'package:musso_deme_app/test_audio.dart'; // Import de l'écran de test audio
import 'package:musso_deme_app/services/audio_service.dart'; // Import du service audio
import 'package:provider/provider.dart'; // Import de provider

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AudioService(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Musso Deme App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false, 
      initialRoute: '/Demarrage',
      routes: {
        '/Demarrage': (context) => Demarrage(),
        '/Connexion': (context) => LoginScreen(),
        '/InscriptionScreen': (context) => InscriptionScreen(),
        '/ConfirmationScreen': (context) => Confirmationscreen(),
        '/HomeScreen': (context) => HomeScreen(),
        '/ValiderInscription': (context) => const ValiderInscription(),
        '/ValiderConnexion': (context) => const ValiderConnexion(), // Ajout de la nouvelle route
        '/TestAudio': (context) => const AudioTestScreen(), // Ajout de la route de test audio
      },
    );
  }
}