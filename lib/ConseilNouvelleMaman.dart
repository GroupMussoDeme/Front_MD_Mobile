import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart'; // Ajout de l'import pour la lecture audio
import 'package:musso_deme_app/constants/assets.dart'; // Ajout de l'import pour les assets
import 'package:musso_deme_app/pages/AudioContentScreen.dart';
import 'package:musso_deme_app/pages/AudiosDroits.dart';

class _NewMomsAdviceScreen extends StatefulWidget {
  const _NewMomsAdviceScreen();

  @override
  State<_NewMomsAdviceScreen> createState() => _NewMomsAdviceScreenState();
}

class _NewMomsAdviceScreenState extends State<_NewMomsAdviceScreen> {
  late AudioPlayer _audioPlayer; // Ajout du lecteur audio
  bool _isPlayingAudio = false; // État de lecture de l'audio

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _playMaternalAdviceAudio(); // Lecture de l'audio de conseil maternel au démarrage
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Libération des ressources audio
    super.dispose();
  }

  // Lecture de l'audio de conseil maternel
  Future<void> _playMaternalAdviceAudio() async {
    try {
      await _audioPlayer.setAsset(AppAssets.audioConseilMaternelle);
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
      print('Erreur lors de la lecture de l\'audio de conseil maternel: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AudioContentScreen(
        screenTitle: 'Conseils aux nouvelles mamans',
        introMessage: 'Bienvenue dans l\'espace santé de la femmes.\nÉcouter des conseils sur la santé en Bambara.',
        tracks: newMomsAdviceTracks,
      ),
    );
  }
}

final List<AudioTrack> newMomsAdviceTracks = [
  AudioTrack(icon: Icons.favorite_border, title: 'Conseil pour les femmes enceintes', duration: '10 min 30 s', isPlaying: true),
  AudioTrack(icon: Icons.favorite_border, title: 'Conseil pour les nouvelles mères', duration: '10 min 30 s'),
  AudioTrack(icon: Icons.favorite_border, title: 'Conseil pour les femmes enceintes', duration: '10 min 30 s'),
  AudioTrack(icon: Icons.favorite_border, title: 'Conseil pour les nouvelles mères', duration: '10 min 30 s'),
  AudioTrack(icon: Icons.favorite_border, title: 'Conseil pour les femmes enceintes', duration: '10 min 30 s'),
  AudioTrack(icon: Icons.favorite_border, title: 'Conseil pour les nouvelles mères', duration: '10 min 30 s'),
];

final newMomsScreen = _NewMomsAdviceScreen();