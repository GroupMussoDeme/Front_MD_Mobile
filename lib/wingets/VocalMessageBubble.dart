import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_tts/flutter_tts.dart'; // Ajout de l'import pour TTS

class VocalMessageBubble extends StatefulWidget {
  final bool isMe;
  final String duration;
  final Function() onPlay;
  final Function() onDownload;

  const VocalMessageBubble({
    super.key,
    required this.isMe,
    required this.duration,
    required this.onPlay,
    required this.onDownload,
  });

  @override
  State<VocalMessageBubble> createState() => _VocalMessageBubbleState();
}

class _VocalMessageBubbleState extends State<VocalMessageBubble> {
  bool _isPlaying = false;
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8), // Réduction du padding de 10 à 8
      decoration: BoxDecoration(
        color: widget.isMe ? const Color(0xFF5E2B97) : Colors.grey[300],
        borderRadius: BorderRadius.circular(12), // Réduction du border radius de 15 à 12
      ),
      child: Column(
        crossAxisAlignment: widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Barres de fréquence pour simuler un message vocal
          Row(
            children: [
              Icon(
                widget.isMe ? Icons.headset : Icons.headset_mic,
                color: widget.isMe ? Colors.white : const Color(0xFF5E2B97),
                size: 14, // Réduction de la taille de l'icône de 16 à 14
              ),
              const SizedBox(width: 6), // Réduction de l'espacement de 8 à 6
              Expanded(
                child: CustomPaint(
                  size: const Size(double.infinity, 20), // Réduction de la hauteur de 30 à 20
                  painter: FrequencyBarsPainter(isMe: widget.isMe, isPlaying: _isPlaying),
                ),
              ),
              IconButton(
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 14, // Réduction de la taille de l'icône de 16 à 14
                ),
                onPressed: () {
                  setState(() {
                    _isPlaying = !_isPlaying;
                  });
                  widget.onPlay();
                  
                  // Lecture vocale de l'action
                  _speakText(_isPlaying ? "Lecture en cours" : "Lecture en pause");
                },
              ),
            ],
          ),
          const SizedBox(height: 3), // Réduction de l'espacement de 5 à 3
          // Durée et bouton de téléchargement
          Row(
            mainAxisAlignment: widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Text(
                widget.duration,
                style: TextStyle(
                  color: widget.isMe ? Colors.white70 : Colors.black54,
                  fontSize: 8, // Réduction de la taille de la police de 10 à 8
                ),
              ),
              const SizedBox(width: 8), // Réduction de l'espacement de 10 à 8
              IconButton(
                icon: const Icon(Icons.download, size: 14, color: Colors.white), // Réduction de la taille de 16 à 14
                onPressed: () {
                  widget.onDownload();
                  
                  // Lecture vocale de l'action
                  _speakText("Téléchargement en cours");
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FrequencyBarsPainter extends CustomPainter {
  final bool isMe;
  final bool isPlaying;
  final List<double> barHeights;

  FrequencyBarsPainter({required this.isMe, required this.isPlaying})
      : barHeights = List.generate(20, (index) => Random().nextDouble() * 15 + 3); // Réduction du nombre de barres et de leur taille

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isMe ? Colors.white : const Color(0xFF5E2B97)
      ..strokeWidth = 1.5 // Réduction de l'épaisseur du trait de 2 à 1.5
      ..strokeCap = StrokeCap.round;

    final barWidth = size.width / barHeights.length;
    final centerY = size.height / 2;

    for (int i = 0; i < barHeights.length; i++) {
      final x = i * barWidth + barWidth / 2;
      // Correction de l'erreur : millisecondsSinceEpoch au lieu de millisecondsSinceSinceEpoch
      final height = isPlaying ? barHeights[i] * (0.8 + 0.4 * sin(DateTime.now().millisecondsSinceEpoch / 200.0 + i)) : barHeights[i];
      final top = centerY - height / 2;
      final bottom = centerY + height / 2;

      canvas.drawLine(Offset(x, top), Offset(x, bottom), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => isPlaying;
}