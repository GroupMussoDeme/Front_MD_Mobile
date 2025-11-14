import 'package:flutter/material.dart';

// NOTE: J'ai retiré l'import de 'HomeScreen.dart' et 'video_player' 
// car ils ne sont pas nécessaires pour la CooperativePage elle-même.
// J'ai renommé la couleur pour la clarté.
const Color primaryPurple = Color(0xFF4A0072);
const Color neutralWhite = Colors.white;

// --- Widget de chaque ligne de discussion (inchangé) ----
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
        // Logique pour ouvrir le chat de la coopérative
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
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: primaryPurple,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, "Accueil", 0),
              _buildNavItem(Icons.storage, "Formation", 1), // Utilisation de Icons.storage comme dans les autres designs
              _buildNavItem(Icons.person, "Profil", 2),
            ],
          ),
        ),
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