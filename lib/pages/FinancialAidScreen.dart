import 'package:flutter/material.dart';
// NOTE: Assurez-vous d'avoir cet import, l'écran d'appel doit être défini ici.
import 'appel_screen.dart';
import 'DetailsSurMicroCredit.dart';
import 'package:musso_deme_app/utils/navigation_utils.dart';
import 'package:musso_deme_app/wingets/BottomNavBar.dart';
import 'package:musso_deme_app/pages/Formations.dart';
import 'package:musso_deme_app/pages/ProfileScreen.dart'; 
import 'package:just_audio/just_audio.dart'; // Ajout de l'import pour la lecture audio
import 'package:musso_deme_app/constants/assets.dart'; // Ajout de l'import pour les assets

// --- Définition des couleurs de la Charte Graphique ---
const Color primaryViolet = Color(0xFF491B6D);
const Color neutralWhite = Colors.white;
const Color lightGrey = Color(0xFFF0F0F0);
const Color darkGrey = Color(0xFF707070);

class FinancialInstitutionCard extends StatelessWidget {
  final String logoUrl; // URL pour simuler l'image du logo
  final String name;
  final String amountRange;
  final String details;
  final String rate;

  const FinancialInstitutionCard({
    super.key,
    required this.logoUrl,
    required this.name,
    required this.amountRange,
    required this.details,
    required this.rate,
  });

  // Helper pour construire les boutons textuels (Écouter et Voir plus)
  Widget _buildActionButton({
    required String label,
    required VoidCallback onTap,
    required bool isPrimary,
    IconData? icon,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: isPrimary ? primaryViolet : lightGrey,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: isPrimary ? neutralWhite : primaryViolet, size: 20),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: TextStyle(
                color: isPrimary ? neutralWhite : primaryViolet,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: neutralWhite,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Ligne 1: Logo, Nom et Détails principaux
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo de l'institution (Placeholder d'Image)
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: lightGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  // Utilisation d'un widget Image.asset pour le logo (avec un fallback simple)
                  child: Image.asset(
                    logoUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => 
                        Center(child: Text(name.substring(0, 1), style: TextStyle(color: primaryViolet, fontWeight: FontWeight.bold))),
                  ),
                ),
              ),
              const SizedBox(width: 15),

              // Informations sur le financement
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryViolet,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      amountRange,
                      style: const TextStyle(
                        fontSize: 14,
                        color: darkGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      details,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'Taux : $rate',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),
          const Divider(color: lightGrey, height: 1),
          const SizedBox(height: 15),

          // Ligne 2: Boutons d'Action (Écouter, Voir plus, Favori, Téléphoner)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Bouton Écouter (Audio)
              _buildActionButton(
                icon: Icons.volume_up_outlined,
                label: 'Écouter',
                onTap: () { /* Action Écouter */ },
                isPrimary: false,
              ),

              // Bouton Voir plus (Navigation)
              _buildActionButton(
                icon: null, // Pas d'icône pour "Voir plus" dans le design
                label: 'Voir plus',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MicrocreditDetailsScreen(),
                    ),
                  );
                },
                isPrimary: true,
              ),

              // Icône J'aime (Favori)
              IconButton(
                icon: const Icon(Icons.favorite_border, color: darkGrey, size: 28),
                onPressed: () { /* Action Favori */ },
              ),

              // Icône Téléphoner (Contact)
              IconButton(
                icon: const Icon(Icons.call_outlined, color: darkGrey, size: 28),
                // *** ACTION MODIFIÉE ICI ***
                onPressed: () {
                  // Navigue vers l'écran AppelScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppelScreen(
                        contactName: "Service Financement",
                        contactImageUrl: 'assets/images/kafo.png',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class FinancialAidScreen extends StatefulWidget {
  const FinancialAidScreen({super.key});

  @override
  State<FinancialAidScreen> createState() => _FinancialAidScreenState();
}

class _FinancialAidScreenState extends State<FinancialAidScreen> {
  int _selectedIndex = 0;
  late AudioPlayer _audioPlayer; // Ajout du lecteur audio
  bool _isPlayingAudio = false; // État de lecture de l'audio

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _playFinancialInstitutionAudio(); // Lecture de l'audio de l'institution financière au démarrage
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Libération des ressources audio
    super.dispose();
  }

  // Lecture de l'audio de l'institution financière
  Future<void> _playFinancialInstitutionAudio() async {
    try {
      await _audioPlayer.setAsset(AppAssets.audioInstitutionFinanciere);
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
      print('Erreur lors de la lecture de l\'audio de l\'institution financière: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      
      // Si l'utilisateur clique sur l'icône Home (index 0)
      if (index == 0) {
        // Retourner à la page d'accueil
        navigateToHome(context);
      }
      // Si l'utilisateur clique sur l'icône centrale (index 1) - Formations
      else if (index == 1) {
        // Naviguer vers la page Formations
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FormationVideosPage()),
        );
      }
      // Si l'utilisateur clique sur l'icône de profil (index 2)
      else if (index == 2) {
        // Naviguer vers l'écran de profil
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
      }
    });
  }

  // Données simulées des institutions
  final List<Map<String, String>> _institutions = [
    {
      'logo': 'assets/images/kafo.png',
      'name': 'Kafo Jiginew',
      'amount': 'De 10 000 FC à 500 000 FC',
      'details': 'Commerce, Artisanat',
      'rate': '5 % à 10 %',
    },
    {
      'logo': 'assets/images/nyesigiso-1 1.png',
      'name': 'Nyesigiso',
      'amount': 'De 10 000 FC à 500 000 FC',
      'details': 'Commerce, Agriculture, Artisanat',
      'rate': '5 % à 10 %',
    },
    {
      'logo': 'assets/images/BNDA.png',
      'name': 'BIM s.a',
      'amount': 'De 10 000 FC à 500 000 FC',
      'details': 'Commerce, Agriculture, Artisanat',
      'rate': '5 % à 10 %',
    },
    {
      'logo': "'assets/images/BNDA.png'",
      'name': 'Une autre Institution',
      'amount': 'De 50 000 FC à 1 000 000 FC',
      'details': 'Agriculture, Élevage',
      'rate': '6 % à 9 %',
    },
  ];

  @override
  Widget build(BuildContext context) {
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
                          "Aides aux financements",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: neutralWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      // Bouton pour lire l'audio de l'institution financière
                      IconButton(
                        icon: Icon(
                          _isPlayingAudio ? Icons.pause : Icons.volume_up,
                          color: neutralWhite,
                        ),
                        onPressed: _playFinancialInstitutionAudio,
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              child: Column(
                children: _institutions.map((inst) {
                  return FinancialInstitutionCard(
                    logoUrl: inst['logo']!,
                    name: inst['name']!,
                    amountRange: inst['amount']!,
                    details: inst['details']!,
                    rate: inst['rate']!,
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),

      // Barre de navigation avec BottomNavBar widget
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}