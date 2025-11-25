import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart'; // Ajout de l'import pour la lecture audio
import 'package:musso_deme_app/constants/assets.dart'; // Ajout de l'import pour les assets

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
            // Logique de lecture/pause
            print("Playing: ${track.title}");
          },
        ),
      ),
    );
  }
}

// *****************************************************************
// 2. Écran Principal (Droits des femmes)
// *****************************************************************
class DroitsDesFemmesScreen extends StatefulWidget { // Changement de StatelessWidget à StatefulWidget
  const DroitsDesFemmesScreen({super.key});

  @override
  State<DroitsDesFemmesScreen> createState() => _DroitsDesFemmesScreenState();
}

class _DroitsDesFemmesScreenState extends State<DroitsDesFemmesScreen> {
  late AudioPlayer _audioPlayer; // Ajout du lecteur audio
  bool _isPlayingAudio = false; // État de lecture de l'audio

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer(); // Initialisation du lecteur audio
    _playWomenRightsAudio(); // Lecture de l'audio des droits des femmes au démarrage
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Libération des ressources audio
    super.dispose();
  }

  // Lecture de l'audio des droits des femmes
  Future<void> _playWomenRightsAudio() async {
    try {
      await _audioPlayer.setAsset(AppAssets.audioDroitsDesFemmes);
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
      print('Erreur lors de la lecture de l\'audio des droits des femmes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Droits des Femmes'),
        backgroundColor: const Color(0xFF4A0072),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Les Droits des Femmes au Mali',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A0072),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Au Mali, les femmes jouissent de droits protégés par la Constitution et diverses lois nationales. '
              'Ces droits incluent l\'égalité devant la loi, le droit de vote, l\'accès à l\'éducation, '
              'à la santé, et la protection contre les violences basées sur le genre.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 20),
            const Text(
              'Droits Politiques et Juridiques',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A0072),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '• Droit de vote et d\'élection\n'
              '• Accès aux fonctions publiques\n'
              '• Représentation politique\n'
              '• Égalité devant la justice',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 20),
            const Text(
              'Droits Sociaux et Économiques',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A0072),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '• Droit à l\'éducation\n'
              '• Droit à la santé\n'
              '• Accès à l\'emploi\n'
              '• Propriété et gestion des biens\n'
              '• Accès aux crédits et financements',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 20),
            const Text(
              'Protection Juridique',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A0072),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Le Mali a adopté plusieurs lois pour protéger les femmes, notamment :\n\n'
              '• La loi sur le Code de la Famille (2011) qui garantit l\'égalité dans le mariage\n'
              '• La loi sur la lutte contre les violences faites aux femmes et aux enfants\n'
              '• La loi sur l\'excision (2015)\n'
              '• La loi sur la participation des femmes à la vie politique',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 20),
            const Text(
              'Défis et Perspectives',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A0072),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Malgré les avancées légales, des défis subsistent :\n\n'
              '• Application inégale des lois dans les zones rurales\n'
              '• Pratiques culturelles persistantes\n'
              '• Faible représentation politique\n'
              '• Accès limité aux services de santé et à l\'éducation',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: _playWomenRightsAudio, // Lecture de l'audio des droits des femmes
                icon: Icon(_isPlayingAudio ? Icons.pause : Icons.play_arrow),
                label: Text(_isPlayingAudio ? 'En cours de lecture...' : 'Écouter l\'audio'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A0072),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
