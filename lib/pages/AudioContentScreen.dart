import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musso_deme_app/pages/AudiosDroits.dart';
import 'package:musso_deme_app/wingets/AudioTrackTile.dart';
import 'package:musso_deme_app/wingets/CustomAudioPlayerBar.dart';
import 'package:musso_deme_app/wingets/RoundedPurpleContainer.dart';
import 'package:musso_deme_app/pages/Notifications.dart';
import 'package:musso_deme_app/services/audio_service.dart'; // Import du service audio
import 'package:provider/provider.dart'; // Import de provider

const Color _kPrimaryPurple = Color(0xFF5E2B97);
const Color _kBackgroundColor = Colors.white; // Le fond est blanc

class AudioContentScreen extends StatefulWidget {
  final String screenTitle;
  final String introMessage;
  final List<AudioTrack> tracks;

  const AudioContentScreen({
    super.key,
    required this.screenTitle,
    required this.introMessage,
    required this.tracks,
  });

  @override
  State<AudioContentScreen> createState() => _AudioContentScreenState();
}

class _AudioContentScreenState extends State<AudioContentScreen> {
  int _currentPlayingIndex = -1; // -1 = aucune piste de la liste n'est jouée

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _playAudio(int index) async {
    setState(() {
      _currentPlayingIndex = index;
    });

    try {
      final audioService = Provider.of<AudioService>(context, listen: false);
      // Charger le fichier audio depuis les assets (utiliser le fichier WAV qui fonctionne)
      await audioService.playAudio('assets/audios/test.wav', index);
      
      // Afficher un message de succès
      print('Lecture de l\'audio démarrée pour l\'index: $index');
    } catch (e) {
      print('Erreur lors de la lecture audio: $e');
      // Afficher un message d'erreur à l'utilisateur avec plus de détails
      String errorMessage = 'Erreur lors de la lecture audio';
      if (e is Exception) {
        errorMessage = e.toString();
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  void _onTrackTapped(int index) {
    _playAudio(index);
  }

  // --- Widget d'introduction (le bandeau "Bienvenue...") ---
  Widget _buildIntroCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: _kPrimaryPurple.withOpacity(0.05), // Très léger violet
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.introMessage,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Bouton Intro
              ElevatedButton.icon(
                onPressed: () => print('Lecture de l\'intro'),
                icon: const Icon(Icons.play_arrow, color: Colors.white),
                label: const Text('Intro', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kPrimaryPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              // Placeholder pour le petit logo/visage
              const CircleAvatar(
                radius: 18,
                backgroundColor: _kPrimaryPurple,
                child: Icon(Icons.tag_faces_rounded, color: Colors.white, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final audioService = Provider.of<AudioService>(context);
    
    return Scaffold(
      backgroundColor: _kBackgroundColor,

      // 1. AppBar avec le conteneur violet personnalisé (avec flèche de retour et titre)
      appBar: PreferredSize(
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
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8), // Petit espace fixe
                  Expanded(
                    child: Text(
                      widget.screenTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis, // Gérer le débordement avec des points de suspension
                      maxLines: 1, // Limiter à une seule ligne
                      textAlign: TextAlign.center, // Centrer le texte
                    ),
                  ),
                  const SizedBox(width: 8), // Petit espace fixe
                  IconButton(
                    icon: const Icon(Icons.notifications_none, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // 2. Corps de l'écran : Intro + Liste des Pistes
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre de l'écran affiché sous la barre violette
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                widget.screenTitle,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            
            _buildIntroCard(),
            
            // Liste des pistes audio
            ...List.generate(widget.tracks.length, (index) {
              final track = widget.tracks[index];
              return AudioTrackTile(
                leadingIcon: track.icon,
                title: track.title,
                subtitle: track.duration,
                isPlaying: _currentPlayingIndex == index,
                onTap: () => _onTrackTapped(index),
              );
            }),
            
            // Espace pour que la dernière carte ne soit pas cachée par le lecteur en bas
            const SizedBox(height: 120),
          ],
        ),
      ),

      // 3. Barre de lecture audio (RÉUTILISABLE)
      bottomNavigationBar: CustomAudioPlayerBar(player: audioService.player), // Passer l'instance du lecteur
    );
  }
}