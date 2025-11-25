import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart'; // Ajout de l'import pour TTS

class VocalMessageWidget extends StatefulWidget {
  final Function(String) onSendVocalMessage;
  
  const VocalMessageWidget({super.key, required this.onSendVocalMessage});

  @override
  State<VocalMessageWidget> createState() => _VocalMessageWidgetState();
}

class _VocalMessageWidgetState extends State<VocalMessageWidget> {
  bool _isRecording = false;
  Timer? _timer;
  int _recordDuration = 0;
  IconData _micIcon = Icons.mic;
  double _slideDistance = 0.0;
  double _startY = 0.0; // Position de départ du glissement
  GlobalKey _widgetKey = GlobalKey();
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

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _recordDuration = 0;
      _micIcon = Icons.mic;
      _slideDistance = 0.0;
      
      // Lecture vocale de l'action
      _speakText("Enregistrement en cours");
      
      // Démarrer le timer pour simuler l'enregistrement
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _recordDuration++;
          
          // Changer l'icône selon la durée
          if (_recordDuration >= 10) {
            _micIcon = Icons.mic_none;
          } else if (_recordDuration >= 5) {
            _micIcon = Icons.mic_external_on;
          }
        });
      });
    });
  }

  void _updateSlideDistance(double globalY) {
    // Calculer la distance de glissement par rapport à la position de départ
    double distance = _startY - globalY;
    
    // Ne considérer que le glissement vers le haut
    if (distance > 0) {
      setState(() {
        _slideDistance = distance;
      });
    }
  }

  void _sendRecording() {
    _timer?.cancel();
    
    setState(() {
      _isRecording = false;
      _micIcon = Icons.mic;
      _slideDistance = 0.0;
      _startY = 0.0;
    });
    
    // Envoyer le message vocal simulé
    String vocalMessage = "Message vocal (${_formatDuration(_recordDuration)})";
    widget.onSendVocalMessage(vocalMessage);
    
    // Lecture vocale de l'action
    _speakText("Message vocal envoyé");
  }

  void _cancelRecording() {
    _timer?.cancel();
    
    setState(() {
      _isRecording = false;
      _recordDuration = 0;
      _micIcon = Icons.mic;
      _slideDistance = 0.0;
      _startY = 0.0;
    });
    
    // Lecture vocale de l'action
    _speakText("Enregistrement annulé");
  }

  String _formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: (details) {
        if (!_isRecording) {
          _startRecording();
        }
        // Enregistrer la position de départ du glissement
        _startY = details.globalPosition.dy;
      },
      onVerticalDragUpdate: (details) {
        if (_isRecording) {
          _updateSlideDistance(details.globalPosition.dy);
        }
      },
      onVerticalDragEnd: (_) {
        if (_isRecording) {
          // Si l'utilisateur a glissé suffisamment haut, envoyer le message
          if (_slideDistance > 100) {
            _sendRecording();
          } else {
            // Sinon, continuer l'enregistrement jusqu'à ce que l'utilisateur appuie sur la flèche d'envoi
            // Dans cette implémentation simplifiée, nous annulons l'enregistrement
            _cancelRecording();
          }
        }
      },
      onTapDown: (details) {
        if (!_isRecording) {
          _startRecording();
        }
      },
      onTapUp: (_) {
        // Ne pas envoyer automatiquement lors d'un appui simple
        // L'utilisateur doit glisser vers le haut ou appuyer sur la flèche d'envoi
      },
      onTapCancel: () {
        if (_isRecording) {
          _cancelRecording();
        }
      },
      child: Stack(
        children: [
          // Indicateur de glissement
          if (_isRecording && _slideDistance > 0)
            Positioned(
              top: -_slideDistance,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  onPressed: _sendRecording, // Ajout du bouton d'envoi
                ),
              ),
            ),
          
          // Bouton microphone principal
          Container(
            key: _widgetKey,
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _isRecording ? Colors.red : const Color(0xFF5E2B97),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              _micIcon,
              color: Colors.white,
              size: 28,
            ),
          ),
          
          // Affichage de la durée d'enregistrement
          if (_isRecording)
            Positioned(
              bottom: -20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _formatDuration(_recordDuration),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}