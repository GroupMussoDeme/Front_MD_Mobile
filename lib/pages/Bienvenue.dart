import 'package:flutter/material.dart';
import 'package:musso_deme_app/pages/Ecoute.dart'; // Import de la page Ecoute

class BienvenuePage extends StatelessWidget {
  const BienvenuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Card du haut avec border-radius en bas
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height / 2,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF491B6D),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Texte "Bienvenue sur"
                  const Text(
                    'Bienvenue sur',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  
                  // Texte "MusoDeme"
                  const Text(
                    'MusoDeme',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Microphone dans un cercle blanc - avec GestureDetector pour la navigation
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EcoutePage()),
                      );
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.mic,
                        color: Color(0xFF491B6D),
                        size: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Image de fond (partie basse) - placée par-dessus le card pour chevaucher
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height / 2 + 20, // Un peu plus haut pour chevaucher
            child: Image.asset(
              'assets/images/welcome_background.png',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}