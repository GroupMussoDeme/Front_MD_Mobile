import 'package:flutter/material.dart';
import 'package:musso_deme_app/pages/AudiosDroits.dart';
import 'package:musso_deme_app/wingets/AudioTrackTile.dart';
import 'package:musso_deme_app/wingets/CustomAudioPlayerBar.dart';
import 'package:musso_deme_app/wingets/RoundedPurpleContainer.dart';
import 'package:musso_deme_app/pages/Notifications.dart';

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
  // Simuler la piste actuellement en cours de lecture pour l'état d'icône
  int _currentPlayingIndex = -1; // -1 = aucune piste de la liste n'est jouée

  void _onTrackTapped(int index) {
    setState(() {
      // Si la même piste est re-tapée, on la met en pause (ou changez de logique)
      if (_currentPlayingIndex == index) {
        _currentPlayingIndex = -1;
      } else {
        _currentPlayingIndex = index;
      }
    });
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
                  const Spacer(),
                  Text(
                    widget.screenTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
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
      bottomNavigationBar: const CustomAudioPlayerBar(),
    );
  }
}