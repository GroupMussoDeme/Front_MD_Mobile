import 'package:flutter/material.dart';
import 'package:musso_deme_app/models/chat_message.dart';

class MediaMessageBubble extends StatelessWidget {
  final ChatMessage message;
  
  const MediaMessageBubble({
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
                
                // Bulle du message média
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
                      // Aperçu du média
                      _buildMediaPreview(context),
                      // Heure d'envoi
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
  
  Widget _buildMediaPreview(BuildContext context) {
    switch (message.type) {
      case MessageType.image:
        return ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
            message.content,
            width: 200,
            height: 150,
            fit: BoxFit.cover,
          ),
        );
      
      case MessageType.video:
        return Container(
          width: 200,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Placeholder pour l'image de la vidéo
              Container(
                color: Colors.grey[300],
                child: const Icon(
                  Icons.videocam,
                  size: 40,
                  color: Colors.grey,
                ),
              ),
              // Bouton de lecture
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ],
          ),
        );
      
      case MessageType.audio:
        return Container(
          width: 200,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.audiotrack,
                color: Colors.grey,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message.content.split('/').last,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(
                Icons.play_arrow,
                color: Colors.grey,
              ),
            ],
          ),
        );
      
      case MessageType.document:
        return Container(
          width: 200,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.description,
                color: Colors.grey,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message.content.split('/').last,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(
                Icons.download,
                color: Colors.grey,
              ),
            ],
          ),
        );
      
      default:
        return const SizedBox.shrink();
    }
  }
  
  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}