import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart'; // Ajout de l'import pour la lecture audio
import 'package:musso_deme_app/constants/assets.dart'; // Ajout de l'import pour les assets
import 'package:musso_deme_app/ConseilNouvelleMaman.dart';
import 'package:musso_deme_app/pages/AudioContentScreen.dart';
import 'package:musso_deme_app/pages/ChatScreen.dart';
import 'package:musso_deme_app/pages/DroitsDesEnfants.dart';
import 'package:musso_deme_app/pages/DroitsDesFemmes.dart';
import 'package:musso_deme_app/pages/NutritionScreen.dart';
import 'package:musso_deme_app/pages/FinancialAidScreen.dart';
import 'package:musso_deme_app/pages/RuralMarketScreen.dart';
import 'package:musso_deme_app/pages/Formations.dart';
import 'package:musso_deme_app/pages/cooperative_page.dart';
import 'package:musso_deme_app/pages/ProfileScreen.dart';
import 'package:musso_deme_app/pages/NotificationScreen.dart'; // Ajout de l'import
import 'package:musso_deme_app/pages/ModernChatScreen.dart'; // Ajout de l'import pour la nouvelle page de chat
import 'package:musso_deme_app/pages/ConversationListScreen.dart'; // Ajout de l'import pour la liste des conversations
import 'package:musso_deme_app/services/user_preferences_service.dart'; // Ajout de l'import pour le service de préférences utilisateur
import 'package:musso_deme_app/wingets/BottomNavBar.dart';
import 'package:musso_deme_app/wingets/CurvedText.dart'; // Ajout de l'import
import 'package:musso_deme_app/wingets/SpeakerIcon.dart'; // Changement d'import
import 'package:musso_deme_app/pages/AudiosDroits.dart'; // Import pour AudioTrack
import 'dart:math' as math;

// --- Définition des couleurs principales ---
const Color primaryViolet = Color(0xFF491B6D);
const Color lightViolet = Color(0xFFEAE1F4);
const Color neutralWhite = Colors.white;
const Color darkGrey = Color(0xFF707070);
const Color labelViolet = Color(0xFF5A2A82); // Couleur du texte courbé

// Définition des pistes audio pour les droits des enfants
final List<AudioTrack> childRightsTracks = [
  AudioTrack(icon: Icons.family_restroom, title: 'Droit de l\'enfant', duration: '3 min 45 s'),
  AudioTrack(icon: Icons.baby_changing_station, title: 'La santé enfantine', duration: '3 min 45 s'),
  AudioTrack(icon: Icons.person_off, title: 'Éviter la mal nutrition enfantine', duration: '3 min 45 s'), // Icône ajustée
  AudioTrack(icon: Icons.medical_services, title: 'Consigne pour enfant malade', duration: '3 min 45 s'),
  AudioTrack(icon: Icons.verified_user, title: 'Droits à la protection', duration: '3 min 45 s'),
];

// Définition des pistes audio pour les droits des femmes
final List<AudioTrack> womenRightsTracks = [
  AudioTrack(title: "Droit à l'éducation", duration: "3 min 45 s", icon: Icons.school_outlined),
  AudioTrack(title: "Droit à la santé et la maternité", duration: "3 min 45 s", icon: Icons.favorite_border),
  AudioTrack(title: "Protection contre la violence", duration: "3 min 45 s", icon: Icons.shield_outlined, isPlaying: true),
  AudioTrack(title: "Droits à l'autonomie financière", duration: "3 min 45 s", icon: Icons.monetization_on_outlined),
  AudioTrack(title: "Droits à la propriété foncière", duration: "3 min 45 s", icon: Icons.home_outlined),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _userName = 'Aminata'; // Valeur par défaut
  late AudioPlayer _audioPlayer; // Ajout du lecteur audio
  bool _isPlayingAudioSequence = false; // État de lecture de la séquence audio

  final List<Map<String, dynamic>> _menuItems = [
    {'title': 'Nutrition', 'icon': Icons.baby_changing_station},
    {'title': 'Droits des enfants', 'icon': Icons.family_restroom},
    {'title': 'Conseils aux mamans', 'icon': Icons.pregnant_woman},
    {'title': 'Droits des femmes', 'icon': Icons.balance},
    {'title': 'Protection contre la violence', 'icon': Icons.shield_outlined},
    {'title': 'Coopératives', 'icon': Icons.group},
    {'title': 'Marchés', 'icon': Icons.shopping_cart},
    {'title': 'Formations', 'icon': Icons.school},
    {'title': 'Aides aux financements', 'icon': Icons.monetization_on},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      // Navigation
      if (index == 0) {
        // Accueil - déjà sur cette page
      } else if (index == 1) {
        // Formation
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FormationVideosPage()),
        );
      } else if (index == 2) {
        // Profil
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer(); // Initialisation du lecteur audio
    _loadUserName();
    
    // Démarrer la lecture de la séquence audio après un court délai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 1), () {
        _playHomeAudioSequence();
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Libération des ressources du lecteur audio
    super.dispose();
  }

  // Fonction pour jouer la séquence d'audios de la page d'accueil
  Future<void> _playHomeAudioSequence() async {
    if (_isPlayingAudioSequence) return;

    setState(() {
      _isPlayingAudioSequence = true;
    });

    try {
      // Jouer l'audio de bienvenue
      await _audioPlayer.setAsset(AppAssets.audioBienvenueAccueil);
      await _audioPlayer.play();

      // Attendre la fin de la lecture de l'audio de bienvenue
      await _audioPlayer.playerStateStream.firstWhere(
        (state) => state.processingState == ProcessingState.completed,
      );

      // Attendre 5 secondes avant de jouer l'audio guide
      await Future.delayed(const Duration(seconds: 5));

      // Jouer l'audio guide
      await _audioPlayer.setAsset(AppAssets.audioGuide);
      await _audioPlayer.play();

      // Attendre la fin de la lecture de l'audio guide
      await _audioPlayer.playerStateStream.firstWhere(
        (state) => state.processingState == ProcessingState.completed,
      );
    } catch (e) {
      print('Erreur lors de la lecture de la séquence audio: $e');
    } finally {
      setState(() {
        _isPlayingAudioSequence = false;
      });
    }
  }

  // Fonction pour arrêter la lecture de la séquence audio
  void _stopHomeAudioSequence() {
    setState(() {
      _isPlayingAudioSequence = false;
    });
    _audioPlayer.stop();
  }

  // Charger le nom de l'utilisateur depuis les préférences
  Future<void> _loadUserName() async {
    final userName = UserPreferencesService.getUserFullName();
    setState(() {
      _userName = userName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: neutralWhite,

      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  // Bandeau violet avec logo centré chevauchant le bas
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 100,
                        decoration: const BoxDecoration(
                          color: primaryViolet,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(40),
                            bottomRight: Radius.circular(40),
                          ),
                        ),
                      ),
                      // Icône notification
                      Positioned(
                        right: 15,
                        top: 10,
                        child: IconButton(
                          icon: const Icon(
                            Icons.notifications_none,
                            color: neutralWhite,
                            size: 28,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NotificationScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      // Icône de discussion
                      Positioned(
                        right: 60,
                        top: 10,
                        child: IconButton(
                          icon: const Icon(
                            Icons.chat_bubble_outline,
                            color: neutralWhite,
                            size: 28,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ConversationListScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      // Logo centré descendant un peu en bas du bandeau
                      Positioned(
                        top: 55, // <-- ajuste ici pour descendre plus ou moins
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: neutralWhite,
                              shape: BoxShape.circle,
                              border: Border.all(color: primaryViolet, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/images/logo.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 60), // espace ajusté après le logo
                  // Image principale
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/image1.png', // Remplace par ton image
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Message de bienvenue
                  Text(
                    "Bienvenue $_userName...",
                    style: const TextStyle(
                      color: primaryViolet,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Grille des options principales avec texte courbé
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 25,
                      crossAxisSpacing: 15,
                      childAspectRatio: 0.85,
                      children: List.generate(_menuItems.length, (index) {
                        final item = _menuItems[index];
                        return GestureDetector(
                          onTap: () {
                            final title = item['title'];
                            switch (title) {
                              case 'Nutrition':
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const NutritionScreen(),
                                  ),
                                );
                                break;
                              case 'Droits des enfants':
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AudioContentScreen(
                                      screenTitle: 'Droits des enfants',
                                      introMessage:
                                          'Bienvenue dans l\'espace droit des',
                                      tracks: childRightsTracks,
                                    ),
                                  ),
                                );
                                break;
                              case 'Droits des femmes':
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AudioContentScreen(
                                      screenTitle: 'Droits des femmes',
                                      introMessage:
                                          'Bienvenue dans l\'espace droit des femmes.\nÉcouter vos droits expliques en Bambara.',
                                      tracks: womenRightsTracks,
                                    ),
                                  ),
                                );
                                break;
                              case 'Conseils aux mamans':
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AudioContentScreen(
                                      screenTitle: 'Conseils aux mamans',
                                      introMessage:
                                          'Bienvenue dans l\'espace santé de la femmes.\nÉcouter des conseils sur la santé en Bambara.',
                                      tracks: newMomsAdviceTracks,
                                    ),
                                  ),
                                );
                                break;
                              case 'Protection contre la violence':
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AudioContentScreen(
                                      screenTitle: 'Protection contre la violance',
                                      introMessage:
                                          'Bienvenue dans l\'espace santé de la femmes.\nÉcouter des conseils sur la santé en Bambara.',
                                      tracks: newMomsAdviceTracks,
                                    ),
                                  ),
                                );
                                break;
                              case 'Marchés':
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => RuralMarketScreen(),
                                  ),
                                );
                                break;
                              case 'Aides aux financements':
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const FinancialAidScreen(),
                                  ),
                                );
                                break;
                              case 'Formations':
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const FormationVideosPage(),
                                  ),
                                );
                                break;
                              case 'Coopératives':
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const CooperativePage(),
                                  ),
                                );
                                break;
                              default:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TopicPage(title: title),
                                  ),
                                );
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Texte courbé au-dessus du cercle
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  return Transform.translate(
                                    offset: Offset(0.0, constraints.maxHeight * 0.05),
                                    child: _buildCurvedText(item['title']),
                                  );
                                },
                              ),
                              // Cercle icône
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  return Transform.translate(
                                    offset: Offset(0.0, -constraints.maxHeight * 0.1),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        // Cercle gris clair
                                        Container(
                                          width: constraints.maxWidth * 0.2,
                                          height: constraints.maxWidth * 0.2,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: lightViolet,
                                          ),
                                        ),
                                        // Icône violette
                                        Icon(
                                          item['icon'],
                                          color: primaryViolet,
                                          size: constraints.maxWidth * 0.1,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            // Ajout de l'icône de haut-parleur
            const SpeakerIcon(),
          ],
        ),
      ),

      // Barre de navigation inférieure
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  // Fonction pour créer du texte courbé
  Widget _buildCurvedText(String text) {
    // Utiliser le widget CurvedText personnalisé pour créer un texte qui suit une courbe
    // Placer le texte juste au-dessus et près du cercle
    return LayoutBuilder(
      builder: (context, constraints) {
        return CurvedText(
          text: text,
          radius: constraints.maxWidth * 0.15, // Rayon responsive basé sur la largeur
          color: const Color(0xFF5A1A82),
          textSize: constraints.maxWidth * 0.03, // Taille de texte responsive
        );
      },
    );
  }
}

// --- Page générique ---
class TopicPage extends StatelessWidget {
  final String title;
  const TopicPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: primaryViolet, title: Text(title)),
      body: Center(
        child: Text(
          "Page : $title",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}