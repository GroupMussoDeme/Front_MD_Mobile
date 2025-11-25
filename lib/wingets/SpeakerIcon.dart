import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart'; // Ajout de l'import pour TTS
import 'package:just_audio/just_audio.dart'; // Ajout de l'import pour la lecture audio
import 'package:musso_deme_app/constants/assets.dart'; // Ajout de l'import pour les assets
import 'package:musso_deme_app/wingets/NumericKeypad.dart';
import 'package:musso_deme_app/pages/Formations.dart';
import 'package:musso_deme_app/pages/AudiosDroits.dart'; // Import pour DroitsDesFemmesScreen
import 'package:musso_deme_app/pages/DroitsDesEnfants.dart'; // Import pour l'instance d'écran
import 'package:musso_deme_app/ConseilNouvelleMaman.dart'; // Import pour l'instance d'écran
import 'package:musso_deme_app/pages/NutritionScreen.dart';
import 'package:musso_deme_app/pages/FinancialAidScreen.dart';
import 'package:musso_deme_app/pages/RuralMarketScreen.dart';
import 'package:musso_deme_app/pages/TelechargementScreen.dart';
import 'package:musso_deme_app/pages/cooperative_page.dart';
import 'package:musso_deme_app/pages/HomeScreen.dart';
import 'package:musso_deme_app/pages/ProfileScreen.dart';

class SpeakerIcon extends StatefulWidget {
  const SpeakerIcon({super.key});

  @override
  State<SpeakerIcon> createState() => _SpeakerIconState();
}

class _SpeakerIconState extends State<SpeakerIcon> {
  bool _isKeypadVisible = false;
  String _inputText = '';
  late FlutterTts _flutterTts; // Ajout de TTS
  late AudioPlayer _audioPlayer; // Ajout du lecteur audio pour le clavier numérique
  bool _isPlayingLoop = false; // État de lecture en boucle

  @override
  void initState() {
    super.initState();
    _flutterTts = FlutterTts();
    _audioPlayer = AudioPlayer(); // Initialisation du lecteur audio
    _initTts();
  }

  // Initialisation de TTS
  Future<void> _initTts() async {
    await _flutterTts.setLanguage("fr-FR");
    await _flutterTts.setSpeechRate(0.9);
    // Optionnel : voix féminine
    final voices = await _flutterTts.getVoices;
    final female = voices.firstWhere(
      (v) => v['locale'].toString().startsWith('fr') && (v['gender'] ?? '').toString().contains('female'),
      orElse: () => voices.firstWhere((v) => v['locale'].toString().startsWith('fr'), orElse: () => voices[0]),
    );
    await _flutterTts.setVoice({"name": female['name'], "locale": female['locale']});
  }

  // Lecture audio du texte
  Future<void> _speakText(String text) async {
    await _flutterTts.speak(text);
  }

  // Lecture en boucle de l'audio du clavier numérique
  Future<void> _playKeyboardAudioLoop() async {
    if (_isPlayingLoop) return;

    setState(() {
      _isPlayingLoop = true;
    });

    try {
      await _audioPlayer.setAsset(AppAssets.audioClavierNumerique);
      
      // Jouer en boucle tant que le clavier est visible
      while (_isPlayingLoop && _isKeypadVisible) {
        await _audioPlayer.play();
        
        // Attendre la fin de la lecture
        await _audioPlayer.playerStateStream.firstWhere(
          (state) => state.processingState == ProcessingState.completed,
        );
        
        // Vérifier si le clavier est toujours visible
        if (!_isKeypadVisible) break;
      }
    } catch (e) {
      print('Erreur lors de la lecture de l\'audio du clavier numérique: $e');
    } finally {
      setState(() {
        _isPlayingLoop = false;
      });
    }
  }

  // Arrêter la lecture en boucle
  void _stopKeyboardAudioLoop() {
    setState(() {
      _isPlayingLoop = false;
    });
    _audioPlayer.stop();
  }

  // Lecture de l'audio de déconnexion
  Future<void> _playLogoutAudio() async {
    try {
      await _audioPlayer.setAsset(AppAssets.audioDeconnexion);
      await _audioPlayer.play();
    } catch (e) {
      print('Erreur lors de la lecture de l\'audio de déconnexion: $e');
    }
  }

  void _toggleKeypad() {
    setState(() {
      _isKeypadVisible = !_isKeypadVisible;
      if (_isKeypadVisible) {
        _inputText = '';
        // Lire un message d'instruction quand le clavier s'ouvre
        _speakText("Clavier numérique activé. Veuillez saisir un numéro.");
        // Démarrer la lecture en boucle de l'audio du clavier numérique
        _playKeyboardAudioLoop();
      } else {
        // Lire un message quand le clavier se ferme
        _speakText("Clavier numérique fermé.");
        // Arrêter la lecture en boucle
        _stopKeyboardAudioLoop();
      }
    });
  }

  // Gérer la navigation selon le chiffre pressé
  void _handleNavigation(String digit) {
    switch (digit) {
      case '1':
        // Naviguer vers la page Formation
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FormationVideosPage()),
        );
        break;
      case '2':
        // Naviguer vers la page DroitsDesFemmes
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DroitsDesFemmesScreen()),
        );
        break;
      case '3':
        // Naviguer vers la page DroitsDesEnfants
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => childRightsScreen),
        );
        break;
      case '4':
        // Naviguer vers la page ConseilNouvelleMaman
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => newMomsScreen),
        );
        break;
      case '5':
        // Naviguer vers la page Nutrition
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NutritionScreen()),
        );
        break;
      case '6':
        // Naviguer vers la page FinancialAidScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FinancialAidScreen()),
        );
        break;
      case '7':
        // Naviguer vers la page RuralMarketScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RuralMarketScreen()),
        );
        break;
      case '8':
        // Naviguer vers la page TelechargementScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TelechargementScreen()),
        );
        break;
      case '9':
        // Naviguer vers la page cooperative_page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CooperativePage()),
        );
        break;
      case '0':
        // Naviguer vers la page HomeScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case '*':
        // Naviguer vers la page ProfileScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;
      case '#':
        // Afficher le popup de déconnexion et lire l'audio de déconnexion
        _showLogoutDialog();
        _playLogoutAudio();
        break;
    }
    
    // Arrêter la lecture en boucle quand un chiffre est sélectionné
    _stopKeyboardAudioLoop();
  }

  // Afficher le popup de déconnexion
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Déconnexion"),
          content: const Text("Êtes-vous sûr de vouloir vous déconnecter ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialogue
              },
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialogue
                // Ici, vous pouvez ajouter la logique de déconnexion
                _performLogout();
              },
              child: const Text("Valider"),
            ),
          ],
        );
      },
    );
  }

  // Effectuer la déconnexion
  void _performLogout() {
    // Ajoutez ici la logique de déconnexion (effacer les préférences utilisateur, etc.)
    // Pour l'instant, nous allons simplement afficher un message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Déconnexion effectuée")),
    );
    
    // Vous pouvez ajouter ici la navigation vers la page de connexion
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  void _handleKeyPress(String key) {
    setState(() {
      _inputText += key;
    });
    
    // Lire le chiffre à haute voix
    _speakText(key);
    
    // Gérer la navigation
    _handleNavigation(key);
  }

  void _handleBackspace() {
    setState(() {
      if (_inputText.isNotEmpty) {
        _inputText = _inputText.substring(0, _inputText.length - 1);
        _speakText("Effacé");
      }
    });
  }

  void _handleCall(String phoneNumber) {
    // Action à effectuer lors de l'appel
    if (phoneNumber.isNotEmpty) {
      _speakText("Appel en cours avec le numéro: $phoneNumber");
    } else {
      _speakText("Veuillez saisir un numéro avant d'appeler");
    }
    
    // Cacher le clavier après l'appel
    setState(() {
      _isKeypadVisible = false;
      _inputText = '';
    });
    
    // Arrêter la lecture en boucle
    _stopKeyboardAudioLoop();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _audioPlayer.dispose(); // Libération des ressources du lecteur audio
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Icône de haut-parleur
        Positioned(
          left: 10,
          top: 100, // Positionné sous l'app bar
          child: GestureDetector(
            onTap: _toggleKeypad,
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Color(0xFF491B6D), // Couleur violette comme dans l'application
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.volume_up, // Changement d'icône en haut-parleur
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
        
        // Clavier numérique (affiché lorsque l'icône est cliquée)
        if (_isKeypadVisible)
          Positioned(
            left: 10,
            top: 160,
            child: NumericKeypad(
              onKeyPress: _handleKeyPress,
              onBackspace: _handleBackspace,
              onCall: _handleCall,
              onNavigation: _handleNavigation, // Passage de la fonction de navigation
            ),
          ),
          
        // Affichage du texte saisi
        if (_isKeypadVisible && _inputText.isNotEmpty)
          Positioned(
            left: 10,
            top: 160,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                _inputText,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}