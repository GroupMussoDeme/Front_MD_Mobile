import 'package:flutter/material.dart';
import 'package:musso_deme_app/models/chat_message.dart';

class TextMessageBubble extends StatelessWidget {
  final ChatMessage message;
  
  const TextMessageBubble({
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
                
                // Bulle du message texte
                Container(
                  margin: EdgeInsets.only(
                    left: isMe ? 50.0 : 0.0,
                    right: isMe ? 0.0 : 50.0,
                  ),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: isMe 
                        ? const Color(0xFFEAE1F4) // Violet clair pour les messages envoyés
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Contenu du message
                      Text(
                        message.content,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      // Indicateur de statut et heure
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
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