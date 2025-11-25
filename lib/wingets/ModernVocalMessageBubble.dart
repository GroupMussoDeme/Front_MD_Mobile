import 'package:flutter/material.dart';
import 'dart:math';

class ModernVocalMessageBubble extends StatefulWidget {
  final bool isMe;
  final String duration;
  final VoidCallback onPlay;
  final VoidCallback onDownload;

  const ModernVocalMessageBubble({
    super.key,
    required this.isMe,
    required this.duration,
    required this.onPlay,
    required this.onDownload,
  });

  @override
  State<ModernVocalMessageBubble> createState() => _ModernVocalMessageBubbleState();
}

class _ModernVocalMessageBubbleState extends State<ModernVocalMessageBubble> {
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 250,
      decoration: BoxDecoration(
        color: widget.isMe 
            ? Colors.white.withOpacity(0.2) 
            : const Color(0xFF5A1A82).withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          // Bouton Play rond
          Container(
            margin: const EdgeInsets.only(left: 8),
            width: 35,
            height: 35,
            decoration: const BoxDecoration(
              color: Color(0xFF5A1A82),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _isPlaying = !_isPlaying;
                });
                widget.onPlay();
              },
            ),
          ),
          
          // Onde sonore
          Expanded(
            child: CustomPaint(
              size: const Size(double.infinity, 30),
              painter: WaveformPainter(
                isMe: widget.isMe,
                isPlaying: _isPlaying,
              ),
            ),
          ),
          
          // Durée
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: Text(
              widget.duration,
              style: TextStyle(
                color: widget.isMe ? Colors.white : const Color(0xFF5A1A82),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Peintre pour l'onde sonore
class WaveformPainter extends CustomPainter {
  final bool isMe;
  final bool isPlaying;

  WaveformPainter({required this.isMe, required this.isPlaying});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isMe ? Colors.white : const Color(0xFF5A1A82)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final barCount = 25;
    final barWidth = size.width / barCount;
    final centerY = size.height / 2;

    for (int i = 0; i < barCount; i++) {
      // Créer une hauteur variable pour chaque barre
      double height;
      if (isPlaying) {
        // Hauteur animée pendant la lecture
        height = 5 + (20 * (0.5 + 0.5 * sin(DateTime.now().millisecondsSinceEpoch / 200.0 + i)));
      } else {
        // Hauteur statique quand en pause
        height = 5 + (15 * (0.5 + 0.5 * (i % 3 == 0 ? 0.7 : i % 2 == 0 ? 0.4 : 0.9)));
      }
      
      final top = centerY - height / 2;
      final bottom = centerY + height / 2;
      final x = i * barWidth + barWidth / 2;

      canvas.drawLine(Offset(x, top), Offset(x, bottom), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => isPlaying;
}