import 'package:flutter/material.dart';
import 'package:musso_deme_app/wingets/BottomNavBar.dart';
import 'package:musso_deme_app/pages/GroupChatScreen.dart';
import 'package:musso_deme_app/pages/NewCooperativeScreen.dart';
import 'package:musso_deme_app/pages/Notifications.dart';
import 'package:musso_deme_app/utils/navigation_utils.dart';
import 'package:musso_deme_app/pages/Formations.dart';
import 'package:just_audio/just_audio.dart'; // Ajout de l'import pour la lecture audio
import 'package:musso_deme_app/constants/assets.dart'; // Ajout de l'import pour les assets

// NOTE: J'ai retiré l'import de 'HomeScreen.dart' et 'video_player' 
// car ils ne sont pas nécessaires pour la CooperativePage elle-même.
// J'ai renommé la couleur pour la clarté.
const Color primaryPurple = Color(0xFF4A0072);
const Color neutralWhite = Colors.white;

// --- Widget de chaque ligne de discussion (modifié pour la redirection) ----
class CooperativeTile extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final String date;

  const CooperativeTile({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 26,
        // Assurez-vous que l'asset 'assets/images/cooperative.png' existe et est déclaré dans pubspec.yaml
        backgroundImage: AssetImage(imagePath), 
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(subtitle),
      trailing: Text(
        date,
        style: const TextStyle(color: Colors.black54, fontSize: 13),
      ),
      onTap: () {
        // Redirection vers GroupChatScreen lors du clic sur une coopérative
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const GroupChatScreen(),
          ),
        );
      },
    );
  }
}

// *****************************************************************
// Page Principale (mise à jour avec l'en-tête et le footer de FormationVideosPage)
// *****************************************************************
class CooperativePage extends StatefulWidget {
  const CooperativePage({super.key});

  @override
  State<CooperativePage> createState() => _CooperativePageState();
}

class _CooperativePageState extends State<CooperativePage> {
  // L'index sélectionné (simulé ici, à connecter à un contrôleur de navigation si besoin)
  int _selectedIndex = 0; 
  late AudioPlayer _audioPlayer; // Ajout du lecteur audio
  bool _isPlayingAudio = false; // État de lecture de l'audio
  
  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _playCooperativeAudio(); // Lecture de l'audio de coopérative au démarrage
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Libération des ressources audio
    super.dispose();
  }

  // Lecture de l'audio de coopérative
  Future<void> _playCooperativeAudio() async {
    try {
      await _audioPlayer.setAsset(AppAssets.audioCooperative); // Utilisation de l'audio existant pour les coopératives
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
      print('Erreur lors de la lecture de l\'audio de coopérative: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: neutralWhite,
      body: Column(
        children: [
          // 1. HEADER (Remplacement du Padding et Row précédents)
          Container(
            decoration: const BoxDecoration(
              color: primaryPurple,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Icône de retour (flèche)
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: neutralWhite,
                          size: 26,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(); 
                        },
                      ),
                      // Titre de la page (Coopérative)
                      const Text(
                        "Coopératives", // Changé de "Vidéos de formations"
                        style: TextStyle(
                          color: neutralWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      // Bouton pour lire l'audio de coopérative
                      IconButton(
                        icon: Icon(
                          _isPlayingAudio ? Icons.pause : Icons.volume_up,
                          color: neutralWhite,
                          size: 26,
                        ),
                        onPressed: _playCooperativeAudio,
                      ),
                      // Bouton d'ajout (Icône +)
                      Container(
                        decoration: const BoxDecoration(
                          color: primaryPurple, // Déjà dans le conteneur principal, mais peut être utile
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          // Remplacement de l'icône volume_up par l'icône add
                          icon: const Icon(Icons.add, color: neutralWhite, size: 26),
                          onPressed: () {
                            // Action pour ajouter une coopérative
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewCooperativeScreenRevised(),
                              ),
                            );
                          },

                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // 2. CORPS DE LA PAGE (Liste des messages)
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 0), // Enlève le padding du ListView si ListTile en a
              children: const [
                CooperativeTile(
                  imagePath: 'assets/images/cooperative.png',
                  title: 'MussoDèmè',
                  subtitle: 'Aïssa : Bonjour',
                  date: '26/10/2025',
                ),
                CooperativeTile(
                  imagePath: 'assets/images/cooperative.png',
                  title: 'MussoSutura',
                  subtitle: 'Aïssa : 🎙️1:07',
                  date: '26/10/2025',
                ),
                CooperativeTile(
                  imagePath: 'assets/images/cooperative.png',
                  title: 'ANMUSOW',
                  subtitle: 'Aïssa : 📹 Appel vidéo',
                  date: '26/10/2025',
                ),
                CooperativeTile(
                  imagePath: 'assets/images/cooperative.png',
                  title: 'Mussow',
                  subtitle: 'Aïssa : 📞 Appel vical',
                  date: '26/10/2025',
                ),
                // Ajoutez plus de CooperativeTile ici si nécessaire
              ],
            ),
          ),
        ],
      ),

      // 3. FOOTER NAVIGATION (Remplacement de BottomNavigationBar)
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
            
            // Gestion de la navigation selon l'index
            if (index == 0) {
              // Navigation vers la page d'accueil
              navigateToHome(context);
            } else if (index == 1) {
              // Navigation vers la page Formations
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FormationVideosPage()),
              );
            }
            // Pour l'index 2 (icône de profil), on reste sur la même page
            // car cette page est déjà une page de coopérative
          });
        },
      ),
    );
  }

  // Fonction pour construire les éléments de la navigation inférieure (adaptée de _FormationVideosPageState)
  Widget _buildNavItem(
    IconData icon,
    String label,
    int index,
  ) {
    bool active = (_selectedIndex == index);
    
    // NOTE: Pour que cet état soit fonctionnel, vous devez implémenter la navigation réelle.
    // Pour l'instant, seul l'état visuel est géré par setState.
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        // Ici, vous ajouteriez la logique de navigation vers l'écran correspondant (Accueil, Formation, Profil)
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 32, color: active ? neutralWhite : neutralWhite.withOpacity(0.7)),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: active ? neutralWhite : neutralWhite.withOpacity(0.7),
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}