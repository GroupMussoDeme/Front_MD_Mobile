import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musso_deme_app/pages/NutritionScreen.dart';
import 'package:musso_deme_app/pages/FinancialAidScreen.dart';
import 'package:musso_deme_app/pages/RuralMarketScreen.dart';
import 'package:musso_deme_app/pages/Formations.dart';
import 'package:musso_deme_app/pages/GroupChatScreen.dart';
import 'package:musso_deme_app/pages/cooperative_page.dart';
import 'package:musso_deme_app/pages/ProfileScreen.dart';
import 'package:musso_deme_app/widgets/BottomNavBar.dart';
import 'package:musso_deme_app/pages/DroitsScreens.dart';
import 'package:musso_deme_app/widgets/VocalIcon.dart';
import 'dart:math' as math;

// --- Définition des couleurs principales ---
const Color primaryViolet = Color(0xFF491B6D);
const Color lightViolet = Color(0xFFEAE1F4);
const Color neutralWhite = Colors.white;
const Color darkGrey = Color(0xFF707070);
const Color labelViolet = Color(0xFF5A2A82); // Couleur du texte courbé

// --- Widget personnalisé pour le texte courbé professionnel ---
class CurvedText extends StatelessWidget {
  final String text;
  final double radius;
  final TextStyle style;

  const CurvedText({
    super.key,
    required this.text,
    this.radius = 50,
    TextStyle? style,
    required int startAngle,
    required int endAngle,
  }) : style = style ?? const TextStyle();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CurvedTextPainter(text: text, radius: radius, style: style),
      size: Size(radius * 2, radius * 2),
    );
  }
}

class CurvedTextPainter extends CustomPainter {
  final String text;
  final double radius;
  final TextStyle style;

  CurvedTextPainter({
    required this.text,
    required this.radius,
    required this.style,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    // Créer un arc de 120 degrés centré en haut
    final arcAngle = 120.0 * math.pi / 180.0; // 120 degrés en radians
    final startAngle = -math.pi / 2 - arcAngle / 2; // Commencer en haut centré

    // Calculer l'angle entre chaque lettre
    final anglePerLetter = arcAngle / (text.length + 1);

    for (int i = 0; i < text.length; i++) {
      final letter = text[i];
      final letterSpan = TextSpan(text: letter, style: style);
      final letterPainter = TextPainter(
        text: letterSpan,
        textDirection: TextDirection.ltr,
      );

      letterPainter.layout();

      // Positionner chaque lettre le long de l'arc
      final letterAngle = startAngle + anglePerLetter * (i + 1);
      final letterX = center.dx + radius * math.cos(letterAngle);
      final letterY = center.dy + radius * math.sin(letterAngle);

      // Calculer la rotation pour que chaque lettre suive la courbure
      final rotation = letterAngle + math.pi / 2;

      // Créer une matrice de transformation pour positionner et orienter la lettre
      final transform = Matrix4.identity()
        ..translate(letterX, letterY)
        ..rotateZ(rotation);

      canvas.save();
      canvas.transform(transform.storage);

      // Dessiner la lettre centrée sur l'origine
      letterPainter.paint(
        canvas,
        Offset(-letterPainter.width / 2, -letterPainter.height / 2),
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    _playAudios();
  }

  void _playAudios() async {
    try {
      // Lecture automatique des audios dans l'ordre spécifié avec un intervalle de 2 secondes
      await Future.delayed(const Duration(seconds: 1)); // Délai initial avant de commencer
      await audioPlayer.setAsset("assets/audios/BienvenueAccuiel.aac");
      await audioPlayer.play();
      await Future.delayed(const Duration(seconds: 2));
      
      await audioPlayer.setAsset("assets/audios/profil.aac");
      await audioPlayer.play();
      await Future.delayed(const Duration(seconds: 2));
      
      await audioPlayer.setAsset("assets/audios/whatsapp.aac");
      await audioPlayer.play();
      await Future.delayed(const Duration(seconds: 2));
      
      await audioPlayer.setAsset("assets/audios/guide.aac");
      await audioPlayer.play();
    } catch (e) {
      print("Erreur lors de la lecture des audios: $e");
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

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
    // Si l'utilisateur clique sur l'icône de profil (index 2)
    if (index == 2) {
      // Naviguer vers l'écran de profil
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    }
    // Si l'utilisateur clique sur l'icône Home (index 0) alors qu'il est déjà sur HomeScreen
    else if (index == 0) {
      // Ne rien faire car on est déjà sur la page d'accueil
      setState(() {
        _selectedIndex = index;
      });
    }
    // Si l'utilisateur clique sur l'icône centrale (index 1) - Formations
    else if (index == 1) {
      // Naviguer vers la page Formations
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FormationVideosPage()),
      );
    } else {
      // Pour les autres icônes, mettre à jour l'index sélectionné
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: neutralWhite,

      body: SafeArea(
        child: SingleChildScrollView(
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
                  // Icône chat
                  Positioned(
                    right: 65,
                    top: 10,
                    child: IconButton(
                      icon: const Icon(
                        Icons.chat_bubble_outline,
                        color: neutralWhite,
                        size: 28,
                      ),
                      onPressed: () {
                        // Navigation vers le chat
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GroupChatScreen(),
                          ),
                        );
                      },
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
                      onPressed: () {},
                    ),
                  ),
                  // Icône vocale
                  Positioned(
                    left: 15,
                    top: 10,
                    child: VocalIcon(
                      onPressed: () {
                        // TODO: Implémenter la fonctionnalité vocale
                      },
                      isActive: true,
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
              const Text(
                "Bienvenue Aminata...",
                style: TextStyle(
                  color: primaryViolet,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // Grille des options principales
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 25,
                  crossAxisSpacing: 15,
                  childAspectRatio: 0.85,
                  children: _menuItems.map((item) {
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
                                builder: (_) => const DroitsDesEnfantsScreen(),
                              ),
                            );
                            break;

                          case 'Droits des femmes':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const DroitsDesFemmesScreen(),
                              ),
                            );
                            break;

                          case 'Conseils aux mamans':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const ConseilsNouvellesMamansScreen(),
                              ),
                            );
                            break;

                          case 'Protection contre la violence':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const ProtectionViolenceScreen(),
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
                          // Cercle icône
                          Container(
                            width: 85,
                            height: 85,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: lightViolet,
                            ),
                            child: Center(
                              child: Icon(
                                item['icon'],
                                color: primaryViolet,
                                size: 35,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 6,
                          ), // petit espace entre icône et texte
                          // Texte sous l’icône
                          SizedBox(
                            width: 90,
                            child: Text(
                              item['title'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: labelViolet,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),

      // Barre de navigation inférieure
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
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
