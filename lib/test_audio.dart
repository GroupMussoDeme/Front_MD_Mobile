import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:musso_deme_app/wingets/CustomAudioPlayerBar.dart'; // Ajout de l'import
import 'package:musso_deme_app/services/audio_service.dart'; // Import du service audio
import 'package:provider/provider.dart'; // Import de provider

class AudioTestScreen extends StatefulWidget {
  const AudioTestScreen({super.key});

  @override
  State<AudioTestScreen> createState() => _AudioTestScreenState();
}

class _AudioTestScreenState extends State<AudioTestScreen> {
  bool _isPlaying = false;
  String _status = 'Prêt';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _checkAssetExists() async {
    try {
      setState(() {
        _status = 'Vérification du fichier audio...';
      });
      
      // Vérifier si le fichier existe dans les assets
      var manifestContent = await rootBundle.loadString('AssetManifest.json');
      print('Contenu du manifeste: $manifestContent');
      
      // Essayer d'accéder au fichier WAV
      var assetExists = await rootBundle.load('assets/audios/test.wav');
      print('Taille du fichier audio: ${assetExists.lengthInBytes} bytes');
      
      setState(() {
        _status = 'Fichier audio trouvé (${assetExists.lengthInBytes} bytes)';
      });
    } catch (e) {
      print('Erreur lors de la vérification du fichier: $e');
      setState(() {
        _status = 'Erreur: Fichier audio non trouvé - $e';
      });
    }
  }

  Future<void> _playAudio() async {
    try {
      setState(() {
        _status = 'Tentative de chargement du fichier audio...';
      });
      
      print('Tentative de chargement du fichier audio...');
      final audioService = Provider.of<AudioService>(context, listen: false);
      await audioService.playAudio('assets/audios/test.wav', 0);
      print('Fichier audio chargé avec succès');
      setState(() {
        _status = 'Fichier audio chargé avec succès';
        _isPlaying = true;
      });
      
    } catch (e) {
      print('Erreur détaillée lors de la lecture audio: $e');
      setState(() {
        _status = 'Erreur: $e';
        _isPlaying = false;
      });
      
      // Afficher une alerte avec plus de détails
      String errorMessage = e.toString();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erreur de lecture audio'),
            content: Text('Impossible de lire le fichier audio: $errorMessage\n\n'
                'Cela peut être dû à:\n'
                '1. Format de fichier non supporté\n'
                '2. Fichier audio corrompu\n'
                '3. Problème de configuration des assets\n'
                '4. Fichier audio introuvable'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _testNetworkAudio() async {
    try {
      setState(() {
        _status = 'Test avec un fichier audio réseau...';
      });
      
      // Essayer avec un fichier audio connu qui fonctionne
      final audioService = Provider.of<AudioService>(context, listen: false);
      await audioService.player.setUrl('https://www.soundjay.com/misc/sounds/bell-ringing-05.wav');
      await audioService.player.play();
      
      setState(() {
        _status = 'Lecture réseau démarrée avec succès';
        _isPlaying = true;
      });
    } catch (e) {
      print('Erreur lors du test réseau: $e');
      setState(() {
        _status = 'Erreur réseau: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final audioService = Provider.of<AudioService>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Audio'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Test de lecture audio',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _status,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _checkAssetExists,
                    child: const Text('Vérifier le fichier audio'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _playAudio,
                    child: Text(_isPlaying ? 'En cours de lecture...' : 'Jouer l\'audio local'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _testNetworkAudio,
                    child: const Text('Test avec audio réseau'),
                  ),
                ],
              ),
            ),
          ),
          // Lecteur audio interactif en bas
          CustomAudioPlayerBar(player: audioService.player),
        ],
      ),
    );
  }
}