import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musso_deme_app/pages/LoginScreen.dart'; // Import de la page de connexion

class EcoutePage extends StatefulWidget {
  const EcoutePage({super.key});

  @override
  State<EcoutePage> createState() => _EcoutePageState();
}

class _EcoutePageState extends State<EcoutePage> {
  late AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    _playAudio();
  }

  void _playAudio() async {
    try {
      // Arrêter toute lecture en cours
      await audioPlayer.stop();
      
      // Lecture automatique de l'audio "bienvenue 1.aac"
      await audioPlayer.setAsset("assets/audios/bienvenue 1.aac");
      await audioPlayer.play();
    } catch (e) {
      print("Erreur lors de la lecture de l'audio: $e");
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

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