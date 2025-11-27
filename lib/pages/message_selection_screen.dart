import 'package:flutter/material.dart';
import 'package:musso_deme_app/models/chat_message.dart';

class MessageSelectionScreen extends StatelessWidget {
  final List<ChatMessage> selectedMessages;
  final Function(ChatMessage) onMessageAction;
  
  const MessageSelectionScreen({
    super.key,
    required this.selectedMessages,
    required this.onMessageAction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${selectedMessages.length} sélectionné(s)'),
        backgroundColor: const Color(0xFF4A0072),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Aperçu des messages sélectionnés
          Container(
            height: 100,
            padding: const EdgeInsets.all(10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: selectedMessages.length,
              itemBuilder: (context, index) {
                final message = selectedMessages[index];
                return _buildMessagePreview(message);
              },
            ),
          ),
          
          // Options d'action
          Expanded(
            child: ListView(
              children: [
                _buildActionTile(
                  icon: Icons.reply,
                  title: 'Répondre',
                  onTap: () {
                    // TODO: Implémenter la réponse
                    Navigator.pop(context);
                  },
                ),
                _buildActionTile(
                  icon: Icons.forward,
                  title: 'Transférer',
                  onTap: () {
                    // TODO: Implémenter le transfert
                    Navigator.pop(context);
                  },
                ),
                _buildActionTile(
                  icon: Icons.copy,
                  title: 'Copier',
                  onTap: () {
                    // TODO: Implémenter la copie
                    Navigator.pop(context);
                  },
                ),
                _buildActionTile(
                  icon: Icons.delete,
                  title: 'Supprimer',
                  color: Colors.red,
                  onTap: () {
                    // TODO: Implémenter la suppression
                    Navigator.pop(context);
                  },
                ),
                _buildActionTile(
                  icon: Icons.star,
                  title: 'Ajouter aux favoris',
                  onTap: () {
                    // TODO: Implémenter l'ajout aux favoris
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMessagePreview(ChatMessage message) {
    return Container(
      width: 80,
      height: 80,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: message.type == MessageType.text
          ? Center(
              child: Text(
                message.content.length > 20 
                    ? '${message.content.substring(0, 20)}...'
                    : message.content,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            )
          : Icon(
              _getIconForMessageType(message.type),
              size: 30,
              color: Colors.grey,
            ),
    );
  }
  
  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? const Color(0xFF4A0072)),
      title: Text(title),
      onTap: onTap,
    );
  }
  
  IconData _getIconForMessageType(MessageType type) {
    switch (type) {
      case MessageType.image:
        return Icons.image;
      case MessageType.video:
        return Icons.videocam;
      case MessageType.audio:
        return Icons.audiotrack;
      case MessageType.document:
        return Icons.description;
      case MessageType.voice:
        return Icons.mic;
      default:
        return Icons.message;
    }
  }
}