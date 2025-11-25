import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart'; // Ajout de l'import pour TTS
import 'package:musso_deme_app/wingets/NumericKeypad.dart';

class SpeakerIcon extends StatefulWidget {
  const SpeakerIcon({super.key});

  @override
  State<SpeakerIcon> createState() => _SpeakerIconState();
}

class _SpeakerIconState extends State<SpeakerIcon> {
  bool _isKeypadVisible = false;
  String _inputText = '';
  late FlutterTts _flutterTts; // Ajout de TTS

  @override
  void initState() {
    super.initState();
    _flutterTts = FlutterTts();
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

  void _toggleKeypad() {
    setState(() {
      _isKeypadVisible = !_isKeypadVisible;
      if (_isKeypadVisible) {
        _inputText = '';
        // Lire un message d'instruction quand le clavier s'ouvre
        _speakText("Clavier numérique activé. Veuillez saisir un numéro.");
      }
    });
  }

  void _handleKeyPress(String key) {
    setState(() {
      _inputText += key;
    });
    
    // Lire le chiffre à haute voix
    _speakText(key);
  }

  void _handleBackspace() {
    setState(() {
      if (_inputText.isNotEmpty) {
        _inputText = _inputText.substring(0, _inputText.length - 1);
        _speakText("Effacé");
      }
    });
  }

  void _handleCall() {
    // Action à effectuer lors de l'appel
    if (_inputText.isNotEmpty) {
      _speakText("Appel en cours avec le numéro: $_inputText");
    } else {
      _speakText("Veuillez saisir un numéro avant d'appeler");
    }
    
    // Cacher le clavier après l'appel
    setState(() {
      _isKeypadVisible = false;
      _inputText = '';
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
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