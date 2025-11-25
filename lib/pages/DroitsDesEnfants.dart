import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart'; // Ajout de l'import pour la lecture audio
import 'package:musso_deme_app/constants/assets.dart'; // Ajout de l'import pour les assets
import 'package:musso_deme_app/pages/AudioContentScreen.dart';
import 'package:musso_deme_app/pages/AudiosDroits.dart';

class ChildRightsScreen extends StatefulWidget {
  final String screenTitle;
  final String introMessage;
  final List<AudioTrack> tracks;

  const ChildRightsScreen({
    super.key,
    required this.screenTitle,
    required this.introMessage,
    required this.tracks,
  });

  @override
  State<ChildRightsScreen> createState() => _ChildRightsScreenState();
}

class _ChildRightsScreenState extends State<ChildRightsScreen> {
  late AudioPlayer _audioPlayer;
  bool _isPlayingAudio = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _playChildrenRightsAudio(); // Lecture de l'audio des droits des enfants au démarrage
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // Lecture de l'audio des droits des enfants
  Future<void> _playChildrenRightsAudio() async {
    try {
      await _audioPlayer.setAsset(AppAssets.audioDroitDesEnfants);
      await _audioPlayer.play();
      setState(() {
        _isPlayingAudio = true;
      });
      
      // Mettre à jour l'état lorsque la lecture est terminée
      _audioPlayer.playerStateStream.firstWhere(
        (state) => state.processingState == ProcessingState.completed,
      ).then((_) {
        if (mounted) {
          setState(() {
            _isPlayingAudio = false;
          });
        }
      });
    } catch (e) {
      print('Erreur lors de la lecture de l\'audio des droits des enfants: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AudioContentScreen(
        screenTitle: widget.screenTitle,
        introMessage: widget.introMessage,
        tracks: widget.tracks,
      ),
    );
  }
}

// Définition des pistes audio pour les droits des enfants
final List<AudioTrack> childRightsTracks = [
  AudioTrack(icon: Icons.family_restroom, title: 'Droit de l\'enfant', duration: '3 min 45 s'),
  AudioTrack(icon: Icons.baby_changing_station, title: 'La santé enfantine', duration: '3 min 45 s'),
  AudioTrack(icon: Icons.person_off, title: 'Éviter la mal nutrition enfantine', duration: '3 min 45 s'),
  AudioTrack(icon: Icons.medical_services, title: 'Consigne pour enfant malade', duration: '3 min 45 s'),
  AudioTrack(icon: Icons.verified_user, title: 'Droits à la protection', duration: '3 min 45 s'),
];

// Instance d'écran pour les droits des enfants
final childRightsScreen = ChildRightsScreen(
  screenTitle: 'Droits des enfants',
  introMessage: 'Bienvenue dans l\'espace droit des enfants.\nÉcouter vos droits expliques en Bambara.',
  tracks: childRightsTracks,
);