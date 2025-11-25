import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart'; // Ajout de l'import pour TTS
import 'package:just_audio/just_audio.dart'; // Ajout de l'import pour la lecture audio
import 'package:musso_deme_app/constants/assets.dart'; // Ajout de l'import pour les assets

class NumericKeypad extends StatefulWidget {
  final Function(String) onKeyPress;
  final Function()? onBackspace;
  final Function(String)? onCall; // Modification du type pour accepter le numéro
  final Function(String) onNavigation; // Nouvelle fonction de navigation

  const NumericKeypad({
    super.key,
    required this.onKeyPress,
    this.onBackspace,
    this.onCall,
    required this.onNavigation, // Ajout de la fonction de navigation
  });

  @override
  State<NumericKeypad> createState() => _NumericKeypadState();
}

class _NumericKeypadState extends State<NumericKeypad> {
  String _phoneNumber = ''; // Stockage du numéro de téléphone
  bool _showDialer = false; // Affichage du champ de saisie
  late FlutterTts _flutterTts; // Ajout de TTS
  late AudioPlayer _audioPlayer; // Ajout du lecteur audio

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

  // Lecture de l'audio de déconnexion
  Future<void> _playLogoutAudio() async {
    try {
      await _audioPlayer.setAsset(AppAssets.audioDeconnexion);
      await _audioPlayer.play();
    } catch (e) {
      print('Erreur lors de la lecture de l\'audio de déconnexion: $e');
    }
  }

  // Méthode pour ajouter un chiffre au numéro
  void _addDigit(String digit) {
    setState(() {
      _phoneNumber += digit;
    });
    
    // Lecture vocale du chiffre ajouté
    _speakText(digit);
    
    // Gérer la navigation selon le chiffre pressé
    _handleNavigation(digit);
  }

  // Gérer la navigation selon le chiffre pressé
  void _handleNavigation(String digit) {
    widget.onNavigation(digit);
  }

  // Méthode pour effacer le dernier chiffre
  void _backspace() {
    setState(() {
      if (_phoneNumber.isNotEmpty) {
        _phoneNumber = _phoneNumber.substring(0, _phoneNumber.length - 1);
      }
    });
    
    // Lecture vocale de l'action
    _speakText("Effacé");
  }

  // Méthode pour lancer l'appel (simulation)
  void _makeCall() {
    if (_phoneNumber.isNotEmpty) {
      // Appeler la fonction onCall si elle est définie
      if (widget.onCall != null) {
        widget.onCall!(_phoneNumber);
      }
      
      // Lecture vocale de l'action
      _speakText("Appel en cours: $_phoneNumber");
      
      // Afficher un message de confirmation
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Appel en cours: $_phoneNumber')),
        );
      }
      
      // Réinitialiser le numéro après l'appel
      setState(() {
        _phoneNumber = '';
        _showDialer = false;
      });
    } else {
      // Lecture vocale si aucun numéro n'est saisi
      _speakText("Veuillez saisir un numéro avant d'appeler");
    }
  }

  // Méthode pour afficher le champ de saisie
  void _toggleDialer() {
    setState(() {
      _showDialer = !_showDialer;
      if (_showDialer) {
        _phoneNumber = ''; // Réinitialiser le numéro lors de l'ouverture
        // Lecture vocale de l'action
        _speakText("Clavier numérique activé. Veuillez saisir un numéro.");
      } else {
        // Lecture vocale de l'action
        _speakText("Clavier numérique fermé.");
      }
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _audioPlayer.dispose(); // Libération des ressources du lecteur audio
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8), // Rendre le clavier transparent
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Champ de saisie du numéro (affiché uniquement lorsque _showDialer est true)
          if (_showDialer) ...[
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _phoneNumber.isEmpty ? 'Entrez un numéro' : _phoneNumber,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: _toggleDialer,
                  ),
                ],
              ),
            ),
          ],
          
          // Ligne 1
          _buildRow(['1', '2', '3']),
          const SizedBox(height: 15), // Augmenter l'espacement vertical
          // Ligne 2
          _buildRow(['4', '5', '6']),
          const SizedBox(height: 15), // Augmenter l'espacement vertical
          // Ligne 3
          _buildRow(['7', '8', '9']),
          const SizedBox(height: 15), // Augmenter l'espacement vertical
          // Ligne 4
          _buildRow(['*', '0', '#']),
          const SizedBox(height: 15), // Augmenter l'espacement vertical
          // Ligne 5 (Backspace et Call)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Bouton Backspace
              IconButton(
                onPressed: _showDialer ? _backspace : widget.onBackspace,
                icon: const Icon(Icons.backspace, size: 30, color: Colors.red),
              ),
              // Espacement entre les icônes
              const SizedBox(width: 40), // Ajouter de l'espacement entre les icônes
              // Bouton Call
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: _showDialer ? _makeCall : _toggleDialer,
                  icon: Icon(
                    _showDialer ? Icons.phone_forwarded : Icons.phone, 
                    color: Colors.white
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) => _buildKey(key)).toList(),
    );
  }

  Widget _buildKey(String key) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF491B6D).withOpacity(0.8), // Couleur violette avec transparence
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: _showDialer ? () => _addDigit(key) : () => widget.onKeyPress(key),
        icon: Text(
          key,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Texte en blanc pour meilleur contraste
          ),
        ),
      ),
    );
  }
}