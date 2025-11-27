import 'package:flutter/material.dart';
import 'package:musso_deme_app/models/chat_message.dart';

class VoiceMessageBubble extends StatelessWidget {
  final ChatMessage message;
  
  const VoiceMessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // Avatar du contact (seulement pour les messages des autres)
          if (!isMe && message.senderAvatar != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                radius: 15,
                backgroundImage: AssetImage(message.senderAvatar!),
                backgroundColor: colorScheme.primaryContainer,
              ),
            ),
          
          // Conteneur du message
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                // Nom de l'expéditeur (seulement pour les messages des autres et si non vide)
                if (!isMe && message.senderName.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                    child: Text(
                      message.senderName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                
                // Bulle du message vocal
                Container(
                  margin: EdgeInsets.only(
                    left: isMe ? 50.0 : 0.0,
                    right: isMe ? 0.0 : 50.0,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: isMe 
                        ? const Color(0xFFEAE1F4) // Violet clair pour les messages envoyés
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: isMe 
                          ? const Color(0xFFEAE1F4)
                          : Colors.grey.shade300,
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icône Lecture/Pause
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4A0072), // Couleur violette principale
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      
                      // Placeholder pour la forme d'onde
                      SizedBox(
                        width: 120,
                        height: 30,
                        child: CustomPaint(
                          painter: WaveformPainter(color: Colors.grey.shade600),
                        ),
                      ),
                      const SizedBox(width: 8.0),

                      // Durée
                      const Text(
                        '0:20',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      
                      // Icône Microphone
                      const Icon(
                        Icons.mic,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ],
                  ),
                ),
                
                // Heure d'envoi
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icône de statut
                      if (message.status == MessageStatus.sending)
                        const Icon(
                          Icons.access_time,
                          size: 12,
                          color: Colors.grey,
                        )
                      else if (message.status == MessageStatus.sent)
                        const Icon(
                          Icons.done,
                          size: 12,
                          color: Colors.grey,
                        )
                      else if (message.status == MessageStatus.delivered)
                        const Icon(
                          Icons.done_all,
                          size: 12,
                          color: Colors.grey,
                        )
                      else if (message.status == MessageStatus.read)
                        const Icon(
                          Icons.done_all,
                          size: 12,
                          color: Colors.blue,
                        ),
                      const SizedBox(width: 4),
                      // Heure d'envoi
                      Text(
                        _formatTime(message.timestamp),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Avatar de l'utilisateur (seulement pour les messages envoyés)
          if (isMe && message.senderAvatar != null)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: CircleAvatar(
                radius: 15,
                backgroundImage: AssetImage(message.senderAvatar!),
                backgroundColor: colorScheme.primaryContainer,
              ),
            ),
        ],
      ),
    );
  }
  
  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}

// CustomPainter pour simuler la forme d'onde
class WaveformPainter extends CustomPainter {
  final Color color;

  WaveformPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    // Simuler quelques barres de forme d'onde
    final double barWidth = 3.0;
    final double spacing = 4.0;
    
    // Exemple de hauteurs (simulant une onde)
    final List<double> heights = [
      0.3, 0.6, 0.9, 0.7, 0.5, 0.8, 1.0, 0.6, 0.4, 0.7, 0.9, 0.5, 0.3, 0.6, 0.8
    ];
    
    for (int i = 0; i < heights.length; i++) {
      final double x = i * (barWidth + spacing);
      final double barHeight = size.height * heights[i];
      final double y = (size.height - barHeight) / 2;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, barWidth, barHeight),
          const Radius.circular(1.0),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}