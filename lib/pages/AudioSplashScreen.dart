import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musso_deme_app/wingets/CustomAudioPlayerBar.dart'; // Ajout de l'import
import 'package:musso_deme_app/services/audio_service.dart'; // Import du service audio
import 'package:provider/provider.dart'; // Import de provider

// --- Définition des couleurs de la Charte Graphique ---
const Color primaryViolet = Color(0xFF491B6D);
const Color neutralWhite = Colors.white;
const Color lightGrey = Color(0xFFF0F0F0);
const Color accentColor = Color(0xFF8A2BE2); // Pour le dégradé

class AudioChapterItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String duration;
  final bool isPlaying; // Pour déterminer si le bouton est Play ou Pause
  final VoidCallback onActionPressed;

  const AudioChapterItem({
    super.key,
    required this.icon,
    required this.title,
    this.duration = '3 min 45 s',
    this.isPlaying = false,
    required this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      decoration: BoxDecoration(
        color: neutralWhite,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          // Icône à gauche (Dégradé ou Violet Uni)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: lightGrey, // Fond de l'icône
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: primaryViolet,
              size: 24,
            ),
          ),
          const SizedBox(width: 15),

          // Texte (Titre & Durée)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryViolet,
                  ),
                ),
                Text(
                  duration,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Bouton Play/Pause
          IconButton(
            icon: Icon(
              isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
              color: primaryViolet,
              size: 40,
            ),
            onPressed: onActionPressed,
          ),
        ],
      ),
    );
  }
}

// *****************************************************************

class WomenRightsScreen extends StatefulWidget {
  const WomenRightsScreen({super.key});

  @override
  State<WomenRightsScreen> createState() => _WomenRightsScreenState();
}

class _WomenRightsScreenState extends State<WomenRightsScreen> {
  int _selectedIndex = 0;
  // Simuler le statut de lecture global
  bool _isGlobalAudioPlaying = true; 
  // Simuler le chapitre en cours de lecture
  int _currentPlayingIndex = 2; // Index 2 correspond à "Protection contre la violence"

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
      // Afficher un message d'erreur à l'utilisateur si le contexte est disponible
      // Nous ne pouvons pas utiliser ScaffoldMessenger ici car ce n'est pas un widget
    }
  }

  // Liste des chapitres
  final List<Map<String, dynamic>> _chapters = [
    {'title': 'Droit à l\'éducation', 'icon': Icons.school, 'duration': '3 min 45 s'},
    {'title': 'Droit à la santé et la maternité', 'icon': Icons.favorite_border, 'duration': '3 min 45 s'},
    {'title': 'Protection contre la violence', 'icon': Icons.security, 'duration': '3 min 45 s'},
    {'title': 'Droits à l\'autonomie financière', 'icon': Icons.autorenew, 'duration': '3 min 45 s'},
    {'title': 'Droits à la propriété foncière', 'icon': Icons.home_outlined, 'duration': '3 min 45 s'},
  ];

  @override
  Widget build(BuildContext context) {
    final audioService = Provider.of<AudioService>(context);
    
    return Scaffold(
      backgroundColor: lightGrey,
      appBar: null,
      
      body: Stack(
        children: [
          // Header violet arrondi
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              decoration: const BoxDecoration(
                color: primaryViolet,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: neutralWhite),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const Expanded(
                        child: Text(
                          "Droits des femmes",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: neutralWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications_none, color: neutralWhite),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Contenu scrollable
          Positioned.fill(
            top: 100,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 2. Panneau d'Introduction Audio
                        _buildIntroPanel(),
                        
                        const SizedBox(height: 15),

                        // 3. Liste des chapitres audio
                        ..._chapters.asMap().entries.map((entry) {
                          final index = entry.key;
                          final item = entry.value;
                          return AudioChapterItem(
                            icon: item['icon'] as IconData,
                            title: item['title'] as String,
                            duration: item['duration'] as String,
                            isPlaying: _currentPlayingIndex == index, // Met en pause celui qui correspond
                            onActionPressed: () {
                              setState(() {
                                // Logique simple de bascule Play/Pause
                                _currentPlayingIndex = _currentPlayingIndex == index ? -1 : index; 
                                // Jouer l'audio
                                _playAudio(index);
                              });
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ),

                // 4. Barre de contrôle audio inférieure
                CustomAudioPlayerBar(player: audioService.player), // Utiliser le nouveau lecteur audio
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Widgets pour l'Introduction ---
  Widget _buildIntroPanel() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: neutralWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Bienvenue dans l'espace droit des femmes.\nEcouter vos droits expliques en Bambara.",
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  // Jouer l'audio d'introduction
                  _playAudio(-1);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    color: primaryViolet,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.play_arrow, color: neutralWhite, size: 20),
                      SizedBox(width: 5),
                      Text("Intro", style: TextStyle(color: neutralWhite, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              // Simuler le logo d'un partenaire
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.lightBlue.shade200,
                  shape: BoxShape.circle,
                ),
                child: const Center(child: Text("B", style: TextStyle(color: Colors.white, fontSize: 16))),
              )
            ],
          ),
        ],
      ),
    );
  }
}