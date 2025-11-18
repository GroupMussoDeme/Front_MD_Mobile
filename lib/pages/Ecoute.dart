import 'package:flutter/material.dart';
import 'package:musso_deme_app/pages/LoginScreen.dart'; // Import de la page de connexion

class EcoutePage extends StatelessWidget {
  const EcoutePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF491B6D), // Fond violet foncé
      body: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        },
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF491B6D),
            borderRadius: BorderRadius.all(Radius.circular(20)), // Coins arrondis
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Aligner les éléments en haut
            children: [
              const SizedBox(height: 100), // Espace en haut de la page
              
              // Texte "Bienvenue sur" - centré en haut
              const Text(
                'Bienvenue sur',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                ),
              ),
              
              // Texte "MusoDeme" - centré en haut
              const Text(
                'MusoDeme',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 60),
              
              // Icône d'oreille centrée au milieu de la page
              const Expanded(
                child: Center(
                  child: Icon(
                    Icons.hearing, // Icône d'oreille
                    color: Colors.white,
                    size: 150, // Grande taille
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}