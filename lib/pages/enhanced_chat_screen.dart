import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:musso_deme_app/models/chat_message.dart';
import 'package:musso_deme_app/services/chat_service.dart';
import 'package:musso_deme_app/widgets/text_message_bubble.dart';
import 'package:musso_deme_app/widgets/media_message_bubble.dart';
import 'package:musso_deme_app/widgets/voice_message_bubble.dart';
import 'package:musso_deme_app/widgets/enhanced_chat_input_bar.dart';

// Définition des couleurs de la charte graphique
const Color _kPrimaryPurple = Color(0xFF4A0072); // Couleur violette principale
const Color _kLightPurple = Color(0xFFEAE1F4); // Violet clair
const Color _kBackgroundColor = Colors.white;

class EnhancedChatScreen extends StatefulWidget {
  const EnhancedChatScreen({super.key});

  @override
  State<EnhancedChatScreen> createState() => _EnhancedChatScreenState();
}

class _EnhancedChatScreenState extends State<EnhancedChatScreen> {
  late ChatService _chatService;
  bool _isSelecting = false;
  final Set<String> _selectedMessages = <String>{};
  
  @override
  void initState() {
    super.initState();
    _chatService = ChatService('group1');
    _chatService.loadMessageHistory();
  }
  
  @override
  void dispose() {
    _chatService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _chatService,
      child: Scaffold(
        backgroundColor: _kBackgroundColor,
        appBar: _buildAppBar(),
        body: Column(
          children: [
            Expanded(
              child: Consumer<ChatService>(
                builder: (context, chatService, child) {
                  final messages = chatService.getSortedMessages();
                  return ListView.builder(
                    reverse: false,
                    padding: const EdgeInsets.all(12.0),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return _buildMessageBubble(message);
                    },
                  );
                },
              ),
            ),
            EnhancedChatInputBar(
              onSendText: _handleSendText,
              onSendVoice: _handleSendVoice,
              onSendMedia: _handleSendMedia,
            ),
          ],
        ),
      ),
    );
  }
  
  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100.0),
      child: Container(
        height: 100,
        decoration: const BoxDecoration(
          color: _kPrimaryPurple,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25.0),
            bottomRight: Radius.circular(25.0),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                // Icône de retour
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                // Image de profil du groupe/contact
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/cooperative.png'), // Placeholder
                  radius: 18,
                ),
                const SizedBox(width: 10),
                // Nom du groupe
                const Text(
                  'MussoDèmè',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                
                // Mode sélection
                if (_isSelecting)
                  IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white),
                    onPressed: _clearSelection,
                  ),
                
                // Icône Notification
                IconButton(
                  icon: const Icon(Icons.notifications_none, color: Colors.white, size: 28),
                  onPressed: () {
                    // TODO: Implémenter les notifications
                  },
                ),
                // Icône Vidéo
                IconButton(
                  icon: const Icon(Icons.videocam, color: Colors.white, size: 28),
                  onPressed: () {
                    // TODO: Implémenter l'appel vidéo
                  },
                ),
                // Icône Appel
                IconButton(
                  icon: const Icon(Icons.call, color: Colors.white, size: 28),
                  onPressed: () {
                    // TODO: Implémenter l'appel vocal
                  },
                ),
                // Menu trois points
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white, size: 28),
                  onSelected: _handleMenuSelection,
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem<String>(
                        value: 'group_info',
                        child: Text('Informations du groupe'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'media',
                        child: Text('Médias, liens et docs'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'search',
                        child: Text('Rechercher dans la discussion'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'mute',
                        child: Text('Mettre en sourdine'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'clear',
                        child: Text('Effacer les messages'),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem<String>(
                        value: 'exit',
                        child: Text('Quitter le groupe'),
                      ),
                    ];
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildMessageBubble(ChatMessage message) {
    // Gestion de la sélection
    if (_isSelecting) {
      return GestureDetector(
        onLongPress: () => _toggleMessageSelection(message.id),
        onTap: () => _toggleMessageSelection(message.id),
        child: Stack(
          children: [
            _getMessageBubble(message),
            if (_selectedMessages.contains(message.id))
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
          ],
        ),
      );
    } else {
      return GestureDetector(
        onLongPress: () => _toggleMessageSelection(message.id),
        child: _getMessageBubble(message),
      );
    }
  }
  
  Widget _getMessageBubble(ChatMessage message) {
    switch (message.type) {
      case MessageType.text:
        return TextMessageBubble(message: message);
      case MessageType.image:
      case MessageType.video:
      case MessageType.audio:
      case MessageType.document:
        return MediaMessageBubble(message: message);
      case MessageType.voice:
        return VoiceMessageBubble(message: message);
      default:
        return const SizedBox.shrink();
    }
  }
  
  void _handleSendText(String text) {
    _chatService.sendTextMessage(text);
  }
  
  void _handleSendVoice(String filePath, Duration duration) {
    _chatService.sendVoiceMessage(filePath, duration);
  }
  
  void _handleSendMedia(String filePath, MediaType type) {
    MessageType messageType;
    switch (type) {
      case MediaType.image:
        messageType = MessageType.image;
        break;
      case MediaType.video:
        messageType = MessageType.video;
        break;
      case MediaType.audio:
        messageType = MessageType.audio;
        break;
      case MediaType.document:
        messageType = MessageType.document;
        break;
    }
    _chatService.sendMediaMessage(filePath, messageType);
  }
  
  void _toggleMessageSelection(String messageId) {
    setState(() {
      if (_isSelecting) {
        if (_selectedMessages.contains(messageId)) {
          _selectedMessages.remove(messageId);
          if (_selectedMessages.isEmpty) {
            _isSelecting = false;
          }
        } else {
          _selectedMessages.add(messageId);
        }
      } else {
        _isSelecting = true;
        _selectedMessages.add(messageId);
      }
    });
  }
  
  void _clearSelection() {
    setState(() {
      _isSelecting = false;
      _selectedMessages.clear();
    });
  }
  
  void _handleMenuSelection(String value) {
    switch (value) {
      case 'group_info':
        // TODO: Naviguer vers l'écran d'informations du groupe
        break;
      case 'media':
        // TODO: Naviguer vers l'écran des médias
        break;
      case 'search':
        // TODO: Ouvrir la recherche dans la discussion
        break;
      case 'mute':
        // TODO: Mettre en sourdine le groupe
        break;
      case 'clear':
        // TODO: Effacer les messages
        break;
      case 'exit':
        // TODO: Quitter le groupe
        break;
    }
  }
}