import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musso_deme_app/pages/RightsBaseScreen.dart';
import 'package:musso_deme_app/pages/backend_audio_content_screen.dart';

/// Droits des femmes
class DroitsDesFemmesScreen extends StatefulWidget {
  const DroitsDesFemmesScreen({super.key});

  @override
  State<DroitsDesFemmesScreen> createState() => _DroitsDesFemmesScreenState();
}

class _DroitsDesFemmesScreenState extends State<DroitsDesFemmesScreen> {
  late AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    _playAudio();
  }

  void _playAudio() async {
    try {
      // Lecture automatique de l'audio "droitdesfemme.aac"
      await Future.delayed(const Duration(milliseconds: 500)); // Petit délai avant de commencer
      await audioPlayer.setAsset("assets/audios/droitdesfemme.aac");
      await audioPlayer.play();
    } catch (e) {
      print("Erreur lors de la lecture de l'audio: $e");
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackendAudioContentScreen(
      screenTitle: 'Droits des femmes',
      introMessage:
          'Bienvenue dans l\'espace droit des femmes.\nEcouter vos droits expliqués en Bambara.',
      typeInfo: 'DROITS_FEMMES',
      typeCategorie: 'AUDIOS',
      defaultIcon: Icons.favorite_border,
    );
  }
}


/// Droits des enfants
class DroitsDesEnfantsScreen extends StatefulWidget {
  const DroitsDesEnfantsScreen({super.key});

  @override
  State<DroitsDesEnfantsScreen> createState() => _DroitsDesEnfantsScreenState();
}

class _DroitsDesEnfantsScreenState extends State<DroitsDesEnfantsScreen> {
  late AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    _playAudio();
  }

  void _playAudio() async {
    try {
      // Lecture automatique de l'audio "droitdes enfant.aac"
      await Future.delayed(const Duration(milliseconds: 500)); // Petit délai avant de commencer
      await audioPlayer.setAsset("assets/audios/droitdes enfant.aac");
      await audioPlayer.play();
    } catch (e) {
      print("Erreur lors de la lecture de l'audio: $e");
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackendAudioContentScreen(
      screenTitle: 'Droits des enfants',
      introMessage:
          'Bienvenue dans l\'espace droit des enfants.\nEcouter vos droits expliqués en Bambara.',
      typeInfo: 'DROITS_ENFANTS',
      typeCategorie: 'AUDIOS',
      defaultIcon: Icons.family_restroom,
    );
  }
}


/// Conseils aux nouvelles mamans
class ConseilsNouvellesMamansScreen extends StatefulWidget {
  const ConseilsNouvellesMamansScreen({super.key});

  @override
  State<ConseilsNouvellesMamansScreen> createState() => _ConseilsNouvellesMamansScreenState();
}

class _ConseilsNouvellesMamansScreenState extends State<ConseilsNouvellesMamansScreen> {
  late AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    _playAudio();
  }

  void _playAudio() async {
    try {
      // Lecture automatique de l'audio "conseil maternelle.aac"
      await Future.delayed(const Duration(milliseconds: 500)); // Petit délai avant de commencer
      await audioPlayer.setAsset("assets/audios/conseil maternelle.aac");
      await audioPlayer.play();
    } catch (e) {
      print("Erreur lors de la lecture de l'audio: $e");
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackendAudioContentScreen(
      screenTitle: 'Conseils aux nouvelles mamans',
      introMessage:
          'Bienvenue dans l\'espace santé de la femme.\nEcouter des conseils en Bambara.',
      typeInfo: 'CONSEILS_NOUVELLES_MAMANS',
      typeCategorie: 'AUDIOS',
      defaultIcon: Icons.pregnant_woman,
    );
  }
}


class ProtectionViolenceScreen extends StatelessWidget {
  const ProtectionViolenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const RightsBaseScreen(
      typeInfo: 'PROTECTION_CONTRE_VIOLENCE',
      screenTitle: 'Protection contre la violence',
      introMessage:
          "Bienvenue dans l'espace de protection.\nEcouter des conseils en Bambara.",
      defaultIcon: Icons.shield_outlined,
    );
  }
}
