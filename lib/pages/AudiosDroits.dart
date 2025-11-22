import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musso_deme_app/wingets/CustomAudioPlayerBar.dart'; // Ajout de l'import
import 'package:musso_deme_app/services/audio_service.dart'; // Import du service audio
import 'package:provider/provider.dart'; // Import de provider

// --- Définition des couleurs de la Charte Graphique ---
const Color primaryViolet = Color(0xFF491B6D);
const Color accentViolet = Color(0xFF6C2FC8); 
const Color neutralWhite = Colors.white;
const Color lightGrey = Color(0xFFF0F0F0);
const Color darkGrey = Color(0xFF707070);

// --- Modèle de données pour les pistes audio ---
class AudioTrack {
  final String title;
  final String duration;
  final IconData icon;
  final bool isPlaying; // Simuler l'état de lecture/pause

  AudioTrack({
    required this.title,
    required this.duration,
    required this.icon,
    this.isPlaying = false,
  });
}

// Données de démonstration
final List<AudioTrack> tracks = [
  AudioTrack(title: "Droit à l'éducation", duration: "3 min 45 s", icon: Icons.school_outlined),
  AudioTrack(title: "Droit à la santé et la maternité", duration: "3 min 45 s", icon: Icons.favorite_border),
  AudioTrack(title: "Protection contre la violence", duration: "3 min 45 s", icon: Icons.shield_outlined, isPlaying: true),
  AudioTrack(title: "Droits à l'autonomie financière", duration: "3 min 45 s", icon: Icons.monetization_on_outlined),
  AudioTrack(title: "Droits à la propriété foncière", duration: "3 min 45 s", icon: Icons.home_outlined),
];

// *****************************************************************
// 1. Composant réutilisable pour une seule ligne d'audio
// *****************************************************************
class AudioListItem extends StatelessWidget {
  final AudioTrack track;

  const AudioListItem({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    // Choisir la couleur de l'icône de lecture/pause
    final playPauseIconColor = track.isPlaying ? neutralWhite : primaryViolet;
    
    // Choisir l'icône de lecture/pause
    final playPauseIcon = track.isPlaying ? Icons.pause : Icons.play_arrow;

    // Choisir le style de la carte (pour le titre "Protection contre la violence")
    final cardColor = track.isPlaying ? accentViolet.withOpacity(0.1) : neutralWhite;
    final iconColor = track.isPlaying ? primaryViolet : primaryViolet;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          // Icône à gauche
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryViolet.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              track.icon,
              color: iconColor,
              size: 28,
            ),
          ),
          
          // Titre et durée au centre
          title: Text(
            track.title,
            style: TextStyle(
              fontWeight: track.isPlaying ? FontWeight.bold : FontWeight.w500,
              color: primaryViolet,
            ),
          ),
          subtitle: Text(
            track.duration,
            style: const TextStyle(color: darkGrey, fontSize: 13),
          ),
          
          // Bouton de lecture/pause à droite
          trailing: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: track.isPlaying ? primaryViolet : neutralWhite,
              border: Border.all(color: primaryViolet, width: 1.5),
            ),
            child: Icon(
              playPauseIcon,
              color: playPauseIconColor,
              size: 30,
            ),
          ),
          onTap: () {
            // Trouver l'index de la piste dans la liste
            final index = tracks.indexOf(track);
            // Accéder à l'état du parent pour jouer l'audio
            (context.findAncestorStateOfType<_DroitsDesFemmesScreenState>() as _DroitsDesFemmesScreenState)._playAudio(index);
          },
        ),
      ),
    );
  }
}

// *****************************************************************
// 2. Écran Principal (Droits des femmes)
// *****************************************************************
class DroitsDesFemmesScreen extends StatefulWidget {
  const DroitsDesFemmesScreen({super.key});

  @override
  State<DroitsDesFemmesScreen> createState() => _DroitsDesFemmesScreenState();
}

class _DroitsDesFemmesScreenState extends State<DroitsDesFemmesScreen> {
  int _currentPlayingIndex = -1;

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
      // Afficher un message d'erreur à l'utilisateur
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la lecture audio: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Composant du "message d'introduction"
  Widget _buildIntroCard() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: neutralWhite,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Bienvenue dans l'espace droit des femmes.",
                  style: TextStyle(color: darkGrey, fontSize: 14),
                ),
                const Text(
                  "Écouter vos droits expliqués en Bambara.",
                  style: TextStyle(color: darkGrey, fontSize: 14),
                ),
                const SizedBox(height: 15),
                // Bouton Intro
                Material(
                  color: primaryViolet,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: () {
                      // Jouer l'audio d'introduction (index -1 pour indiquer l'intro)
                      _playAudio(-1);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.play_arrow, color: neutralWhite, size: 20),
                          SizedBox(width: 8),
                          Text("Intro", style: TextStyle(color: neutralWhite, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Placeholder pour le logo/image de la femme
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: primaryViolet, width: 2),
              color: Colors.lightBlue.shade50, // Couleur de fond du logo
            ),
            child: const Center(
              child: Icon(Icons.sentiment_satisfied_alt, color: Colors.blue, size: 30),
            ),
          )
        ],
      ),
    );
  }

  // ***************************************************************
  // 3. Le Scaffold (Structure de la page)
  // ***************************************************************
  @override
  Widget build(BuildContext context) {
    final audioService = Provider.of<AudioService>(context);
    
    return Scaffold(
      // La couleur de fond derrière la carte blanche
      backgroundColor: lightGrey,
      
      // Barre d'application (App Bar)
      appBar: AppBar(
        backgroundColor: primaryViolet,
        // Éliminer l'ombre par défaut
        elevation: 0, 
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: neutralWhite),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Droits des femmes",
          style: TextStyle(
            color: neutralWhite,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: neutralWhite),
            onPressed: () {},
          ),
        ],
      ),
      
      body: Stack(
        children: [
          // Liste des pistes (le contenu principal)
          Column(
            children: [
              _buildIntroCard(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 120), // Espace pour le lecteur
                  itemCount: tracks.length,
                  itemBuilder: (context, index) {
                    return AudioListItem(track: tracks[index]);
                  },
                ),
              ),
            ],
          ),
          
          // Lecteur de médias en bas (positionné en bas de la pile)
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomAudioPlayerBar(player: audioService.player), // Passer l'instance du lecteur
          ),
        ],
      ),
    );
  }
}