import 'package:flutter/material.dart';

import 'package:musso_deme_app/pages/ProfileScreen.dart';
import 'package:musso_deme_app/wingets/BottomNavBar.dart';
import 'package:musso_deme_app/wingets/VocalMessageWidget.dart';
import 'package:musso_deme_app/wingets/VocalMessageBubble.dart'; // Ajout de l'import pour le nouveau composant
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  final ImagePicker _picker = ImagePicker();
  int _selectedIndex = 0;
  late FlutterTts _flutterTts;
  String _userProfileImageUrl = 'https://img.freepik.com/free-photo/portrait-young-african-woman-with-traditional-clothes_23-2148928488.jpg'; // URL de la photo de profil de l'utilisateur

  @override
  void initState() {
    super.initState();
    // Initialisation de la synthèse vocale
    _flutterTts = FlutterTts();
    _initTts();
    
    // Ajout de messages d'exemple
    _messages.addAll([
      ChatMessage(
        text: "Bonjour, comment allez-vous?",
        sender: "Mariam",
        isMe: false,
        timestamp: "10:30",
        type: MessageType.text,
      ),
      ChatMessage(
        text: "Je vais bien, merci! Et vous?",
        sender: "Moi",
        isMe: true,
        timestamp: "10:32",
        type: MessageType.text,
      ),
      ChatMessage(
        text: "photo_vacances.jpg",
        sender: "Mariam",
        isMe: false,
        timestamp: "10:35",
        type: MessageType.image,
        imageUrl: "https://img.freepik.com/free-photo/portrait-young-african-woman-with-traditional-clothes_23-2148928488.jpg",
      ),
      // Ajout d'un message vocal simulé
      ChatMessage(
        text: "Message vocal (0:30)",
        sender: "Mariam",
        isMe: false,
        timestamp: "10:37",
        type: MessageType.audio,
        duration: "0:30",
      ),
      // Ajout d'un autre message vocal
      ChatMessage(
        text: "Message vocal (1:15)",
        sender: "Moi",
        isMe: true,
        timestamp: "10:40",
        type: MessageType.audio,
        duration: "1:15",
      ),
    ]);
  }

  // Initialisation de la synthèse vocale
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

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(ChatMessage(
          text: _messageController.text,
          sender: "Moi",
          isMe: true,
          timestamp: DateTime.now().hour.toString().padLeft(2, '0') + ':' + DateTime.now().minute.toString().padLeft(2, '0'),
          type: MessageType.text,
        ));
        _messageController.clear();
        
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

  // Nouvelle méthode pour envoyer un message vocal
  void _sendVocalMessage(String vocalMessage) {
    setState(() {
      _messages.add(ChatMessage(
        text: vocalMessage,
        sender: "Moi",
        isMe: true,
        timestamp: DateTime.now().hour.toString().padLeft(2, '0') + ':' + DateTime.now().minute.toString().padLeft(2, '0'),
        type: MessageType.audio,
        duration: vocalMessage.replaceAll("Message vocal (", "").replaceAll(")", ""),
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

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _messages.add(ChatMessage(
          text: "photo_${DateTime.now().millisecondsSinceEpoch}.jpg",
          sender: "Moi",
          isMe: true,
          timestamp: DateTime.now().hour.toString().padLeft(2, '0') + ':' + DateTime.now().minute.toString().padLeft(2, '0'),
          type: MessageType.image,
          imageUrl: image.path,
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
  }

  Future<void> _pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      setState(() {
        _messages.add(ChatMessage(
          text: "video_${DateTime.now().millisecondsSinceEpoch}.mp4",
          sender: "Moi",
          isMe: true,
          timestamp: DateTime.now().hour.toString().padLeft(2, '0') + ':' + DateTime.now().minute.toString().padLeft(2, '0'),
          type: MessageType.video,
          videoUrl: video.path,
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
  }

  void _recordAudio() {
    // Simulation d'un enregistrement audio
    setState(() {
      _messages.add(ChatMessage(
        text: "audio_${DateTime.now().millisecondsSinceEpoch}.mp3",
        sender: "Moi",
        isMe: true,
        timestamp: DateTime.now().hour.toString().padLeft(2, '0') + ':' + DateTime.now().minute.toString().padLeft(2, '0'),
        type: MessageType.audio,
        duration: "0:30",
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      
      // Si l'utilisateur clique sur l'icône Home (index 0)
      if (index == 0) {
        // Retourner à la page d'accueil
        Navigator.pop(context);
      }
      // Si l'utilisateur clique sur l'icône centrale (index 1) - Formations
      else if (index == 1) {
        // Navigation vers formations
      }
      // Si l'utilisateur clique sur l'icône de profil (index 2)
      else if (index == 2) {
        // Navigation vers le profil
      }
    });
  }

  // Fonction pour lire le message d'instruction vocal
  void _playInstructionAudio() {
    _speakText("Vous pouvez envoyer des photos, vidéos, audios ou documents en sélectionnant l'une de ces options.");
  }

  // Méthode pour mettre à jour la photo de profil
  void _updateUserProfileImage(String imageUrl) {
    setState(() {
      _userProfileImageUrl = imageUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF5E2B97),
        title: const Text(
          'Chat',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Icône de profil qui dirige vers la page de profil
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    onProfileImageUpdated: (imageUrl) {
                      setState(() {
                        _userProfileImageUrl = imageUrl;
                      });
                    },
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundImage: NetworkImage(_userProfileImageUrl),
                radius: 16,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Zone des messages
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _buildMessage(_messages[index]);
                },
              ),
            ),
          ),
          
          // Zone de saisie
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              children: [
                // Bouton pour les pièces jointes avec icônes
                PopupMenuButton<String>(
                  icon: const Icon(Icons.add, color: Color(0xFF5E2B97)),
                  onSelected: (String result) {
                    switch (result) {
                      case 'image':
                        _pickImage();
                        break;
                      case 'video':
                        _pickVideo();
                        break;
                      case 'audio':
                        _recordAudio();
                        break;
                    }
                  },
                  onOpened: _playInstructionAudio, // Lecture du message vocal d'instruction
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'image',
                      child: Row(
                        children: [
                          Icon(Icons.camera_alt, color: Color(0xFF5E2B97)),
                          SizedBox(width: 10),
                          Text('Photo'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'video',
                      child: Row(
                        children: [
                          Icon(Icons.videocam, color: Color(0xFF5E2B97)),
                          SizedBox(width: 10),
                          Text('Vidéo'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'audio',
                      child: Row(
                        children: [
                          Icon(Icons.audiotrack, color: Color(0xFF5E2B97)),
                          SizedBox(width: 10),
                          Text('Audio'),
                        ],
                      ),
                    ),
                  ],
                ),
                
                // Champ de texte
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Tapez un message...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                
                // Bouton d'envoi vocal
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: VocalMessageWidget(
                    onSendVocalMessage: _sendVocalMessage,
                  ),
                ),
                
                // Bouton d'envoi texte
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF5E2B97)),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3), // Réduction de la marge verticale de 5 à 3
      child: Row(
        mainAxisAlignment: message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isMe)
            const CircleAvatar(
              radius: 12, // Réduction du radius de 15 à 12
              backgroundColor: Color(0xFF5E2B97),
              child: Icon(Icons.person, color: Colors.white, size: 12), // Réduction de la taille de l'icône de 15 à 12
            ),
          
          const SizedBox(width: 4), // Réduction de l'espacement de 5 à 4
          
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(6), // Réduction du padding de 8 à 6
              decoration: BoxDecoration(
                color: message.isMe ? const Color(0xFF5E2B97) : Colors.grey[300],
                borderRadius: BorderRadius.circular(10), // Réduction du border radius de 12 à 10
              ),
              child: Column(
                crossAxisAlignment: message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (!message.isMe)
                    Text(
                      message.sender,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5E2B97),
                        fontSize: 12, // Réduction de la taille de la police de 14 à 12
                      ),
                    ),
                  
                  switch (message.type) {
                    MessageType.text => Text(
                        message.text,
                        style: TextStyle(
                          color: message.isMe ? Colors.white : Colors.black,
                          fontSize: 12, // Réduction de la taille de la police de 14 à 12
                        ),
                      ),
                    MessageType.image => Column(
                        crossAxisAlignment: message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Lecture directe de l'image au clic
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Affichage de l'image: ${message.text}")),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6), // Réduction du border radius de 8 à 6
                              child: Image.network(
                                message.imageUrl!,
                                width: 100, // Réduction de la taille de 120 à 100
                                height: 60, // Réduction de la taille de 80 à 60
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2), // Réduction de l'espacement de 3 à 2
                          Text(
                            message.text,
                            style: TextStyle(
                              color: message.isMe ? Colors.white70 : Colors.black54,
                              fontSize: 8, // Réduction de la taille de police de 10 à 8
                            ),
                          ),
                          Row(
                            mainAxisAlignment: message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.play_arrow, size: 12, color: Colors.white), // Réduction de la taille de 16 à 12
                                onPressed: () {
                                  // Lecture directe de l'image
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Affichage de l'image: ${message.text}")),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.download, size: 12, color: Colors.white), // Réduction de la taille de 16 à 12
                                onPressed: () {
                                  // Téléchargement de l'image
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Téléchargement de l'image: ${message.text}")),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    MessageType.video => Column(
                        crossAxisAlignment: message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Lecture directe de la vidéo au clic
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Lecture de la vidéo: ${message.text}")),
                              );
                            },
                            child: Container(
                              width: 100, // Réduction de la taille de 120 à 100
                              height: 60, // Réduction de la taille de 80 à 60
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(6), // Réduction du border radius de 8 à 6
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.play_circle_fill,
                                  color: Colors.white,
                                  size: 20, // Réduction de la taille de 30 à 20
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 2), // Réduction de l'espacement de 3 à 2
                          Text(
                            message.text,
                            style: TextStyle(
                              color: message.isMe ? Colors.white70 : Colors.black54,
                              fontSize: 8, // Réduction de la taille de police de 10 à 8
                            ),
                          ),
                          Row(
                            mainAxisAlignment: message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.play_arrow, size: 12, color: Colors.white), // Réduction de la taille de 16 à 12
                                onPressed: () {
                                  // Lecture directe de la vidéo
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Lecture de la vidéo: ${message.text}")),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.download, size: 12, color: Colors.white), // Réduction de la taille de 16 à 12
                                onPressed: () {
                                  // Téléchargement de la vidéo
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Téléchargement de la vidéo: ${message.text}")),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    MessageType.audio => VocalMessageBubble(
                        isMe: message.isMe,
                        duration: message.duration!,
                        onPlay: () {
                          // Lecture directe de l'audio
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Lecture du message vocal: ${message.text}")),
                          );
                        },
                        onDownload: () {
                          // Téléchargement de l'audio
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Téléchargement du message vocal: ${message.text}")),
                          );
                        },
                      ),
                  },
                  
                  Text(
                    message.timestamp,
                    style: TextStyle(
                      color: message.isMe ? Colors.white70 : Colors.black54,
                      fontSize: 6, // Réduction de la taille de police de 8 à 6
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          if (message.isMe)
            const SizedBox(width: 4), // Réduction de l'espacement de 5 à 4
          
          // Avatar de l'utilisateur avec sa photo de profil
          if (message.isMe)
            Container(
              margin: const EdgeInsets.only(right: 4), // Réduction de la marge de 5 à 4
              child: CircleAvatar(
                backgroundImage: NetworkImage(_userProfileImageUrl),
                radius: 12, // Réduction du radius de 15 à 12
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _flutterTts.stop();
    super.dispose();
  }
}

enum MessageType { text, image, video, audio }

class ChatMessage {
  final String text;
  final String sender;
  final bool isMe;
  final String timestamp;
  final MessageType type;
  final String? imageUrl;
  final String? videoUrl;
  final String? duration;

  ChatMessage({
    required this.text,
    required this.sender,
    required this.isMe,
    required this.timestamp,
    required this.type,
    this.imageUrl,
    this.videoUrl,
    this.duration,
  });
}