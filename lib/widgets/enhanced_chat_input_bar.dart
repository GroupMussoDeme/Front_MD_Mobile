import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EnhancedChatInputBar extends StatefulWidget {
  final Function(String) onSendText;
  final Function(String, Duration) onSendVoice;
  final Function(String, MediaType) onSendMedia;
  
  const EnhancedChatInputBar({
    super.key,
    required this.onSendText,
    required this.onSendVoice,
    required this.onSendMedia,
  });

  @override
  State<EnhancedChatInputBar> createState() => _EnhancedChatInputBarState();
}

class _EnhancedChatInputBarState extends State<EnhancedChatInputBar> {
  final TextEditingController _textController = TextEditingController();
  bool _isRecording = false;
  bool _showAttachmentOptions = false;
  
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Options d'attachement (affichées lorsque l'utilisateur clique sur l'icône d'attachement)
          if (_showAttachmentOptions)
            _buildAttachmentOptions(),
          
          // Barre d'entrée principale
          Row(
            children: [
              // Icône Emoji
              IconButton(
                icon: const Icon(Icons.tag_faces, color: Colors.grey),
                onPressed: () {
                  // TODO: Implémenter le sélecteur d'emoji
                },
              ),
              
              // Icône d'attachement
              IconButton(
                icon: const Icon(Icons.attach_file, color: Colors.grey),
                onPressed: () {
                  setState(() {
                    _showAttachmentOptions = !_showAttachmentOptions;
                  });
                },
              ),
              
              // Champ de texte
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAE1F4), // Utilisation du violet clair de la charte
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextField(
                    controller: _textController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      hintText: 'Tapez un message',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(top: 12, bottom: 12),
                    ),
                    onSubmitted: (text) {
                      if (text.trim().isNotEmpty) {
                        widget.onSendText(text);
                        _textController.clear();
                      }
                    },
                  ),
                ),
              ),
              
              // Icône Appareil photo
              IconButton(
                icon: const Icon(Icons.camera_alt, color: Colors.grey),
                onPressed: () {
                  _pickMedia(ImageSource.camera);
                },
              ),

              // Bouton Microphone/Vocal
              GestureDetector(
                onLongPress: _startRecording,
                onLongPressUp: _stopRecording,
                child: Container(
                  margin: const EdgeInsets.only(left: 4.0),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _isRecording 
                        ? Colors.red // Rouge lors de l'enregistrement
                        : const Color(0xFF4A0072), // Couleur violette principale
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isRecording ? Icons.stop : Icons.mic,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              
              // Bouton d'envoi (affiché uniquement lorsque du texte est saisi)
              if (_textController.text.trim().isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF4A0072)),
                  onPressed: () {
                    final text = _textController.text.trim();
                    if (text.isNotEmpty) {
                      widget.onSendText(text);
                      _textController.clear();
                    }
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildAttachmentOptions() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildAttachmentOption(
            icon: Icons.photo_library,
            label: 'Galerie',
            onTap: () => _pickMedia(ImageSource.gallery),
          ),
          _buildAttachmentOption(
            icon: Icons.camera_alt,
            label: 'Caméra',
            onTap: () => _pickMedia(ImageSource.camera),
          ),
          _buildAttachmentOption(
            icon: Icons.audiotrack,
            label: 'Audio',
            onTap: () {
              // TODO: Implémenter le sélecteur de fichiers audio
            },
          ),
          _buildAttachmentOption(
            icon: Icons.video_library,
            label: 'Vidéo',
            onTap: () {
              // TODO: Implémenter le sélecteur de fichiers vidéo
            },
          ),
          _buildAttachmentOption(
            icon: Icons.insert_drive_file,
            label: 'Document',
            onTap: () {
              // TODO: Implémenter le sélecteur de documents
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showAttachmentOptions = false;
        });
        onTap();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: const Color(0xFF4A0072)),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
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
    // Pour l'instant, simulons un envoi
    widget.onSendVoice('assets/audios/sample_voice.aac', const Duration(seconds: 20));
  }
  
  Future<void> _pickMedia(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: source);
      
      if (pickedFile != null) {
        // Cacher les options d'attachement
        setState(() {
          _showAttachmentOptions = false;
        });
        
        // Envoyer le média
        widget.onSendMedia(pickedFile.path, MediaType.image);
      }
    } catch (e) {
      print('Erreur lors de la sélection du média: $e');
      // TODO: Afficher un message d'erreur à l'utilisateur
    }
  }
}

enum MediaType {
  image,
  video,
  audio,
  document,
}