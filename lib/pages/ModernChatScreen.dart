import 'package:flutter/material.dart';
import 'package:musso_deme_app/wingets/BottomNavBar.dart';
import 'package:musso_deme_app/wingets/ModernVocalMessageBubble.dart'; // Import du nouveau widget
import 'package:musso_deme_app/pages/appel_screen.dart'; // Import de la page d'appel
import 'package:image_picker/image_picker.dart'; // Import pour la sélection de fichiers
import 'dart:io'; // Import pour gérer les fichiers
import 'package:audioplayers/audioplayers.dart'; // Ajout pour la lecture audio
import 'package:path_provider/path_provider.dart'; // Ajout pour gérer les fichiers
import 'dart:math'; // Ajout pour générer des noms de fichiers aléatoires

// Enum pour les types de médias
enum MediaType { image, video, audio, document }

// Enum pour les types de messages
enum MessageType { text, image, audio, video, document, sticker }

// Modèle pour les messages
class ChatMessage {
  final String sender;
  final String content;
  final String time;
  final bool isMe;
  final MessageType type;
  final String? duration;
  final String? filePath;

  ChatMessage({
    required this.sender,
    required this.content,
    required this.time,
    required this.isMe,
    required this.type,
    this.duration,
    this.filePath,
  });
}

// Données de test
final List<ChatMessage> sampleMessages = [
  ChatMessage(
    sender: "MussoDèmè",
    content: "Bonjour, bienvenue sur MussoDèmè !",
    time: "10:30",
    isMe: false,
    type: MessageType.text,
  ),
  ChatMessage(
    sender: "Moi",
    content: "Merci, je suis heureuse d'être ici !",
    time: "10:32",
    isMe: true,
    type: MessageType.text,
  ),
  ChatMessage(
    sender: "MussoDèmè",
    content: "Message vocal",
    time: "10:35",
    isMe: false,
    type: MessageType.audio,
    duration: "0:20",
  ),
  ChatMessage(
    sender: "Moi",
    content: "Message vocal",
    time: "10:37",
    isMe: true,
    type: MessageType.audio,
    duration: "0:45",
  ),
];

class ModernChatScreen extends StatefulWidget {
  const ModernChatScreen({super.key});

  @override
  State<ModernChatScreen> createState() => _ModernChatScreenState();
}

class _ModernChatScreenState extends State<ModernChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> _messages = sampleMessages;
  int _selectedIndex = 0;
  final ImagePicker _picker = ImagePicker(); // Pour la sélection de médias
  bool _isRecording = false; // Pour l'enregistrement vocal
  String _recordedAudioPath = ''; // Chemin du fichier audio enregistré
  final AudioPlayer _audioPlayer = AudioPlayer(); // Pour la lecture audio

  void _sendMessage() {
    if (_textController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(ChatMessage(
          sender: "Moi",
          content: _textController.text,
          time: "${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}",
          isMe: true,
          type: MessageType.text,
        ));
        _textController.clear();
        
        // Faire défiler vers le bas
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Fonction pour sélectionner un média
  Future<void> _pickMedia(MediaType mediaType) async {
    try {
      XFile? file;
      
      switch (mediaType) {
        case MediaType.image:
          file = await _picker.pickImage(source: ImageSource.gallery);
          break;
        case MediaType.video:
          file = await _picker.pickVideo(source: ImageSource.gallery);
          break;
        case MediaType.audio:
          // Pour l'audio, nous simulons la sélection
          _sendAudioMessage();
          return;
        case MediaType.document:
          // Pour les documents, nous simulons la sélection
          _sendDocumentMessage();
          return;
      }
      
      if (file != null) {
        setState(() {
          _messages.add(ChatMessage(
            sender: "Moi",
            content: file!.name, // On peut utiliser ! car on a vérifié que file n'est pas null
            time: "${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}",
            isMe: true,
            type: mediaType == MediaType.image ? MessageType.image : MessageType.video,
            filePath: file!.path,
          ));
          
          // Faire défiler vers le bas
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          });
        });
      }
    } catch (e) {
      print("Erreur lors de la sélection du média: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors de la sélection du média")),
      );
    }
  }

  // Envoyer un message audio
  void _sendAudioMessage() {
    setState(() {
      _messages.add(ChatMessage(
        sender: "Moi",
        content: "Message vocal",
        time: "${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}",
        isMe: true,
        type: MessageType.audio,
        duration: "0:15",
      ));
      
      // Faire défiler vers le bas
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    });
  }

  // Envoyer un message document
  void _sendDocumentMessage() {
    setState(() {
      _messages.add(ChatMessage(
        sender: "Moi",
        content: "document.pdf",
        time: "${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}",
        isMe: true,
        type: MessageType.document,
      ));
      
      // Faire défiler vers le bas
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    });
  }

  // Afficher le menu des options de message
  void _showMessageOptions(ChatMessage message) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Options du message",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.copy, color: Color(0xFF5A1A82)),
                title: const Text("Copier"),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Message copié")),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.forward, color: Color(0xFF5A1A82)),
                title: const Text("Transférer"),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Message transféré")),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text("Supprimer"),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _messages.remove(message);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Message supprimé")),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Afficher les stickers
  void _showStickers() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Stickers",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: List.generate(12, (index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        // Ajouter le sticker au message
                        _sendStickerMessage("sticker_$index");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "😊",
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Envoyer un sticker
  void _sendStickerMessage(String sticker) {
    setState(() {
      _messages.add(ChatMessage(
        sender: "Moi",
        content: sticker,
        time: "${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}",
        isMe: true,
        type: MessageType.sticker,
      ));
      
      // Faire défiler vers le bas
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _buildMessageBubble(_messages[index]);
                },
              ),
            ),
          ),
          // Afficher l'interface d'enregistrement vocal si nécessaire
          if (_isRecording)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.red.withOpacity(0.1),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.mic, color: Colors.red, size: 30),
                  SizedBox(width: 10),
                  Text(
                    'Enregistrement en cours...',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          _buildInputBar(),
        ],
      ),
      // Supprimer la barre de navigation en bas
    );
  }

  // Barre supérieure (Header)
  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: AppBar(
        backgroundColor: const Color(0xFF5A1A82),
        leading: Container(
          margin: const EdgeInsets.all(8),
          child: const CircleAvatar(
            backgroundImage: NetworkImage(
              'https://img.freepik.com/free-photo/portrait-young-african-woman-with-traditional-clothes_23-2148928488.jpg',
            ),
          ),
        ),
        title: const Text(
          'MussoDèmè',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone, color: Colors.white),
            onPressed: () {
              // Naviguer vers la page d'appel
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AppelScreen(
                    contactName: "MussoDèmè",
                    contactImageUrl: 'https://img.freepik.com/free-photo/portrait-young-african-woman-with-traditional-clothes_23-2148928488.jpg',
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.white),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (String result) {
              // Gérer les options du menu
              switch (result) {
                case 'delete':
                  // Supprimer la conversation
                  break;
                case 'copy':
                  // Copier les informations
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red, size: 20),
                    SizedBox(width: 10),
                    Text('Supprimer la conversation'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'copy',
                child: Row(
                  children: [
                    Icon(Icons.copy, color: Color(0xFF5A1A82), size: 20),
                    SizedBox(width: 10),
                    Text('Copier les informations'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Barre de saisie
  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          // Icône pour joindre un fichier
          PopupMenuButton<MediaType>(
            icon: const Icon(Icons.attach_file, color: Color(0xFF5A1A82)),
            onSelected: (MediaType mediaType) {
              _pickMedia(mediaType);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<MediaType>>[
              const PopupMenuItem<MediaType>(
                value: MediaType.image,
                child: Row(
                  children: [
                    Icon(Icons.image, color: Color(0xFF5A1A82)),
                    SizedBox(width: 10),
                    Text('Photo'),
                  ],
                ),
              ),
              const PopupMenuItem<MediaType>(
                value: MediaType.video,
                child: Row(
                  children: [
                    Icon(Icons.videocam, color: Color(0xFF5A1A82)),
                    SizedBox(width: 10),
                    Text('Vidéo'),
                  ],
                ),
              ),
              const PopupMenuItem<MediaType>(
                value: MediaType.audio,
                child: Row(
                  children: [
                    Icon(Icons.audiotrack, color: Color(0xFF5A1A82)),
                    SizedBox(width: 10),
                    Text('Audio'),
                  ],
                ),
              ),
              const PopupMenuItem<MediaType>(
                value: MediaType.document,
                child: Row(
                  children: [
                    Icon(Icons.description, color: Color(0xFF5A1A82)),
                    SizedBox(width: 10),
                    Text('Document'),
                  ],
                ),
              ),
            ],
          ),
          
          // Icône sticker
          IconButton(
            icon: const Icon(Icons.emoji_emotions, color: Color(0xFF5A1A82)),
            onPressed: _showStickers,
          ),
          
          // Champ de texte
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  hintText: 'Type a message',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          
          // Icône microphone pour enregistrement vocal
          GestureDetector(
            onTapDown: (_) => _startVoiceRecording(),
            onTapUp: (_) => _stopVoiceRecording(),
            child: Container(
              margin: const EdgeInsets.only(left: 8),
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: _isRecording ? Colors.red : const Color(0xFF5A1A82),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isRecording ? Icons.stop : Icons.mic,
                color: Colors.white,
              ),
            ),
          ),
          
          // Icône d'envoi (visible seulement si du texte est saisi)
          if (_textController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.send, color: Color(0xFF5A1A82)),
              onPressed: _sendMessage,
            ),
        ],
      ),
    );
  }

  // Contenu du message selon son type
  Widget _buildMessageContent(ChatMessage message) {
    switch (message.type) {
      case MessageType.text:
        return Text(
          message.content,
          style: TextStyle(
            color: message.isMe ? Colors.white : Colors.black87,
            fontSize: 14,
          ),
        );
      
      case MessageType.audio:
        return GestureDetector(
          onTap: () {
            if (message.filePath != null) {
              _playVoiceMessage(message.filePath!);
            }
          },
          child: ModernVocalMessageBubble(
            isMe: message.isMe,
            duration: message.duration ?? "0:00",
            onPlay: () {
              // Logique de lecture
              print("Lecture du message vocal");
              if (message.filePath != null) {
                _playVoiceMessage(message.filePath!);
              }
            },
            onDownload: () {
              // Logique de téléchargement
              print("Téléchargement du message vocal");
            },
          ),
        );
      
      case MessageType.image:
        return Container(
          height: 150,
          width: 200,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: message.filePath != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(message.filePath!),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image, color: Colors.grey);
                    },
                  ),
                )
              : const Icon(Icons.image, size: 40, color: Color(0xFF5A1A82)),
        );
      
      case MessageType.video:
        return Container(
          height: 150,
          width: 200,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: message.filePath != null
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(message.filePath!),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image, color: Colors.grey);
                        },
                      ),
                    ),
                    const Icon(
                      Icons.play_circle_fill,
                      size: 50,
                      color: Colors.white70,
                    ),
                  ],
                )
              : const Icon(Icons.play_circle_fill, size: 40, color: Color(0xFF5A1A82)),
        );
      
      case MessageType.document:
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: message.isMe 
                ? Colors.white.withOpacity(0.2) 
                : const Color(0xFF5A1A82).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.description, color: Color(0xFF5A1A82)),
              const SizedBox(width: 10),
              Text(
                message.content,
                style: TextStyle(
                  color: message.isMe ? Colors.white : const Color(0xFF5A1A82),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      
      case MessageType.sticker:
        return Container(
          padding: const EdgeInsets.all(5),
          child: Text(
            message.content,
            style: const TextStyle(fontSize: 40),
          ),
        );
    }
  }

  // Bulle de message
  Widget _buildMessageBubble(ChatMessage message) {
    bool isMe = message.isMe;
    
    return GestureDetector(
      onLongPress: () {
        _showMessageOptions(message);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Avatar de l'expéditeur (à gauche pour les messages reçus)
            if (!isMe)
              Container(
                margin: const EdgeInsets.only(right: 8),
                child: const CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(0xFF5A1A82),
                  child: Text(
                    'M',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            
            // Contenu du message
            Flexible(
              child: Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  // Nom de l'expéditeur (seulement pour les messages reçus)
                  if (!isMe)
                    Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        message.sender,
                        style: const TextStyle(
                          color: Color(0xFF5A1A82),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  
                  // Bulle du message
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe 
                          ? const Color(0xFF5A1A82) // Violet foncé pour mes messages
                          : const Color(0xFFE9DFF0), // Violet très pâle pour les messages reçus
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(isMe ? 16 : 4),
                        topRight: Radius.circular(isMe ? 4 : 16),
                        bottomLeft: const Radius.circular(16),
                        bottomRight: const Radius.circular(16),
                      ),
                    ),
                    child: _buildMessageContent(message),
                  ),
                  
                  // Heure d'envoi
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    child: Text(
                      message.time,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Avatar de l'utilisateur (à droite pour mes messages)
            if (isMe)
              Container(
                margin: const EdgeInsets.only(left: 8),
                child: const CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                    'https://img.freepik.com/free-photo/portrait-young-african-woman-with-traditional-clothes_23-2148928488.jpg',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Fonction pour commencer l'enregistrement vocal
  void _startVoiceRecording() {
    setState(() {
      _isRecording = true;
    });
    
    // Simuler l'enregistrement vocal
    Future.delayed(const Duration(seconds: 3), () {
      if (_isRecording) {
        setState(() {
          _isRecording = false;
          // Générer un chemin de fichier fictif
          _recordedAudioPath = '/data/user/0/com.example.musso_deme_app/cache/audio_${DateTime.now().millisecondsSinceEpoch}.mp3';
        });
        
        // Ajouter le message vocal à la conversation
        _sendVoiceMessage();
      }
    });
  }

  // Fonction pour arrêter l'enregistrement vocal
  void _stopVoiceRecording() {
    setState(() {
      _isRecording = false;
    });
  }

  // Fonction pour envoyer un message vocal
  void _sendVoiceMessage() {
    if (_recordedAudioPath.isNotEmpty) {
      setState(() {
        _messages.add(ChatMessage(
          sender: "Moi",
          content: "Message vocal",
          time: "${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}",
          isMe: true,
          type: MessageType.audio,
          duration: "0:03",
          filePath: _recordedAudioPath,
        ));
        
        // Réinitialiser le chemin du fichier
        _recordedAudioPath = '';
        
        // Faire défiler vers le bas
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      });
    }
  }

  // Fonction pour lire un message vocal
  Future<void> _playVoiceMessage(String filePath) async {
    try {
      // Simuler la lecture du fichier audio
      await _audioPlayer.play(DeviceFileSource(filePath));
      
      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lecture du message vocal')),
      );
    } catch (e) {
      print("Erreur lors de la lecture du message vocal: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors de la lecture du message vocal")),
      );
    }
  }
}
