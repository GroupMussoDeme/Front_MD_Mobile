import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart'; // Ajout de l'import pour la lecture audio
import 'package:musso_deme_app/constants/assets.dart'; // Ajout de l'import pour les assets
import 'package:musso_deme_app/pages/LoginScreen.dart'; // Import de la page de connexion

class EcoutePage extends StatefulWidget { // Changement en StatefulWidget pour gérer l'état
  const EcoutePage({super.key});

  @override
  State<EcoutePage> createState() => _EcoutePageState();
}

class _EcoutePageState extends State<EcoutePage> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _playWelcomeAudio();
  }

  /// Fonction pour jouer l'audio de bienvenue1
  Future<void> _playWelcomeAudio() async {
    try {
      setState(() {
        _isPlaying = true;
      });
      
      await _audioPlayer.setAsset(AppAssets.audioBienvenue1);
      
      // Écouter la fin de la lecture pour naviguer vers la page de connexion
      _audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          _navigateToLogin();
        }
      });
      
      await _audioPlayer.play();
    } catch (e) {
      print('Erreur lors de la lecture de l\'audio de bienvenue1: $e');
      // En cas d'erreur, naviguer quand même vers la page de connexion
      _navigateToLogin();
    }
  }

  /// Fonction pour naviguer vers la page de connexion
  void _navigateToLogin() {
    // Vérifier si le widget est encore monté avant de naviguer
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF491B6D), // Fond violet foncé
      body: GestureDetector(
        onTap: _isPlaying ? null : () { // Désactiver le tap pendant la lecture
          _navigateToLogin();
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
              Expanded(
                child: Center(
                  child: _isPlaying 
                    ? const CircularProgressIndicator( // Afficher un indicateur de progression pendant la lecture
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Icon(
                        Icons.hearing, // Icône d'oreille
                        color: Colors.white,
                        size: 150, // Grande taille
                      ),
                ),
              ),
              
              // Message pendant la lecture
              if (_isPlaying)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Lecture de l\'audio de bienvenue...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
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