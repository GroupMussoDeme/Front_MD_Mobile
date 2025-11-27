import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:musso_deme_app/models/contact.dart';
import 'package:musso_deme_app/models/chat_message.dart';
import 'package:musso_deme_app/services/chat_service.dart';
import 'package:musso_deme_app/widgets/text_message_bubble.dart';
import 'package:musso_deme_app/widgets/media_message_bubble.dart';
import 'package:musso_deme_app/widgets/voice_message_bubble.dart';

class NewChatScreen extends StatefulWidget {
  final Contact contact;
  
  const NewChatScreen({super.key, required this.contact});

  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  late ChatService _chatService;
  final TextEditingController _textController = TextEditingController();
  bool _isRecording = false;
  
  @override
  void initState() {
    super.initState();
    _chatService = ChatService(widget.contact.id);
    _chatService.loadMessageHistory();
  }
  
  @override
  void dispose() {
    _chatService.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _chatService,
      child: Scaffold(
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
            _buildInputBar(),
          ],
        ),
      ),
    );
  }
  
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: widget.contact.profileImage != null
                ? AssetImage(widget.contact.profileImage!)
                : null,
            backgroundColor: Colors.grey[300],
            child: widget.contact.profileImage == null
                ? Icon(
                    Icons.person,
                    color: Colors.grey[600],
                  )
                : null,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.contact.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.contact.isOnline 
                    ? 'En ligne' 
                    : widget.contact.lastSeen ?? 'Hors ligne',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: const Color(0xFF4A0072),
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          icon: const Icon(Icons.videocam),
          onPressed: () {
            // TODO: Implémenter l'appel vidéo
          },
        ),
        IconButton(
          icon: const Icon(Icons.call),
          onPressed: () {
            // TODO: Implémenter l'appel vocal
          },
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            // TODO: Implémenter les options du menu
          },
          itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem<String>(
                value: 'view_contact',
                child: Text('Voir le contact'),
              ),
              const PopupMenuItem<String>(
                value: 'media',
                child: Text('Médias, liens et docs'),
              ),
              const PopupMenuItem<String>(
                value: 'search',
                child: Text('Rechercher dans la discussion'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'mute',
                child: Text('Mettre en sourdine'),
              ),
              const PopupMenuItem<String>(
                value: 'clear',
                child: Text('Effacer les messages'),
              ),
            ];
          },
        ),
      ],
    );
  }
  
  Widget _buildMessageBubble(ChatMessage message) {
    switch (message.type) {
      case MessageType.text:
        return TextMessageBubble(message: message);
      case MessageType.image:
      case MessageType.video:
      case MessageType.document:
        return MediaMessageBubble(message: message);
      case MessageType.voice:
      case MessageType.audio:
        return VoiceMessageBubble(message: message);
      default:
        return Container();
    }
  }
  
  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1.0)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file, color: Colors.grey),
            onPressed: () {
              // TODO: Implémenter les options d'attachement
            },
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: const Color(0xFFEAE1F4),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  hintText: 'Tapez un message',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 12, bottom: 12),
                ),
                onSubmitted: (text) {
                  if (text.trim().isNotEmpty) {
                    _sendMessage(text);
                  }
                },
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt, color: Colors.grey),
            onPressed: () {
              // TODO: Implémenter la prise de photo
            },
          ),
          GestureDetector(
            onLongPress: _startRecording,
            onLongPressUp: _stopRecording,
            child: Container(
              margin: const EdgeInsets.only(left: 4.0),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _isRecording 
                    ? Colors.red
                    : const Color(0xFF4A0072),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isRecording ? Icons.stop : Icons.mic,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          if (_textController.text.trim().isNotEmpty)
            IconButton(
              icon: const Icon(Icons.send, color: Color(0xFF4A0072)),
              onPressed: () {
                final text = _textController.text.trim();
                if (text.isNotEmpty) {
                  _sendMessage(text);
                }
              },
            ),
        ],
      ),
    );
  }
  
  void _sendMessage(String text) {
    _chatService.sendTextMessage(
      text,
      senderId: 'current_user',
      senderName: 'Moi',
    );
    _textController.clear();
  }
  
  void _startRecording() {
    setState(() {
      _isRecording = true;
    });
    // TODO: Implémenter l'enregistrement vocal
  }
  
  void _stopRecording() {
    setState(() {
      _isRecording = false;
    });
    // TODO: Envoyer l'enregistrement vocal
  }
}