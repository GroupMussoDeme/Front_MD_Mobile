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
import 'package:musso_deme_app/services/session_service.dart';
import 'package:musso_deme_app/pages/HistoriquesDesCommandes.dart';
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
  bool _isAudioPlaying = false;
  bool _isKeypadVisible = false;

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

  // Méthode pour lire l'audio du clavier numérique en boucle
  void _playClavierAudioLoop() async {
    setState(() {
      _isAudioPlaying = true;
      _isKeypadVisible = true;
    });
    
    try {
      // Lecture de l'audio "clavierNumérique.aac"
      await audioPlayer.setAsset("assets/audios/clavierNumérique.aac");
      await audioPlayer.play();
      
      // Attendre 2 secondes
      await Future.delayed(const Duration(seconds: 2));
      
      // Relancer la lecture si l'audio doit continuer
      if (_isAudioPlaying) {
        _playClavierAudioLoop();
      }
    } catch (e) {
      print("Erreur lors de la lecture de l'audio: $e");
    }
  }

  // Méthode pour arrêter la lecture audio
  void _stopAudio() {
    setState(() {
      _isAudioPlaying = false;
    });
    audioPlayer.stop();
  }

  // Méthode pour masquer le clavier numérique
  void _hideNumericKeypad() {
    setState(() {
      _isKeypadVisible = false;
      _isAudioPlaying = false;
    });
    audioPlayer.stop();
  }

  // Méthode pour ajouter un chiffre et naviguer
  void _addDigit(String digit) {
    // Arrêter toute lecture audio en cours
    _stopAudio();
    
    // Masquer le clavier
    _hideNumericKeypad();
    
    // Redirection vers différentes pages selon le chiffre entré
    switch (digit) {
      case '1':
        // Direction page formation
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FormationVideosPage()),
        );
        break;
      case '2':
        // Direction page DroitsDesFemmesScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DroitsDesFemmesScreen()),
        );
        break;
      case '3':
        // Direction page DroitsDesEnfantsScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DroitsDesEnfantsScreen()),
        );
        break;
      case '4':
        // Direction page ConseilsNouvellesMamansScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ConseilsNouvellesMamansScreen()),
        );
        break;
      case '5':
        // Direction page NutritionScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NutritionScreen()),
        );
        break;
      case '6':
        // Direction page FinancialAidScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FinancialAidScreen()),
        );
        break;
      case '7':
        // Direction page RuralMarketScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RuralMarketScreen()),
        );
        break;
      case '8':
        // Direction page OrderHistoryScreen (HistoriquesDesCommandes)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
        );
        break;
      case '9':
        // Direction page CooperativeTile
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CooperativePage()),
        );
        break;
      case '0':
        // Direction page accueil (restez sur la même page)
        break;
      case '*':
        // Direction page ProfileScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;
      case '#':
        // Pour la déconnexion avec popup
        _showLogoutDialog();
        break;
    }
  }

  // Méthode pour lire l'audio de déconnexion
  void _playLogoutAudio() async {
    try {
      await audioPlayer.setAsset("assets/audios/deconnexion.aac");
      await audioPlayer.play();
    } catch (e) {
      print("Erreur lors de la lecture de l'audio de déconnexion: $e");
    }
  }

  // Méthode pour afficher le popup de déconnexion
  void _showLogoutDialog() {
    // Lecture de l'audio de déconnexion
    audioPlayer.stop();
    
    // Lecture de l'audio "deconnexion.aac"
    _playLogoutAudio();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Déconnexion'),
          content: const Text('Souhaitez-vous vraiment vous déconnecter ?'),
          actions: [
            // Bouton d'annulation (rouge)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le popup
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.cancel, color: Colors.red),
                  SizedBox(width: 5),
                  Text('Annuler'),
                ],
              ),
            ),
            // Bouton de validation (vert)
            TextButton(
              onPressed: () async {
                // Déconnexion de l'utilisateur
                await SessionService.clearSession();
                
                // Redirection vers la page de démarrage
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false,
                );
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 5),
                  Text('Valider'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // Widget pour le clavier numérique personnalisé
  Widget _buildNumericKeypad() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.transparent, // Palette du clavier transparente
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ligne 1: 1, 2, 3
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeypadButton('1', () => _addDigit('1')),
              _buildKeypadButton('2', () => _addDigit('2')),
              _buildKeypadButton('3', () => _addDigit('3')),
            ],
          ),
          const SizedBox(height: 10),
          
          // Ligne 2: 4, 5, 6
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeypadButton('4', () => _addDigit('4')),
              _buildKeypadButton('5', () => _addDigit('5')),
              _buildKeypadButton('6', () => _addDigit('6')),
            ],
          ),
          const SizedBox(height: 10),
          
          // Ligne 3: 7, 8, 9
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeypadButton('7', () => _addDigit('7')),
              _buildKeypadButton('8', () => _addDigit('8')),
              _buildKeypadButton('9', () => _addDigit('9')),
            ],
          ),
          const SizedBox(height: 10),
          
          // Ligne 4: *, 0, #
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeypadButton('*', () => _addDigit('*')),
              _buildKeypadButton('0', () => _addDigit('0')),
              _buildKeypadButton('#', () => _addDigit('#')),
            ],
          ),
        ],
      ),
    );
  }

  // Widget pour un bouton du clavier numérique
  Widget _buildKeypadButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF491B6D), // Couleur #491B6D
        shape: const CircleBorder(), // Boutons en cercle
        padding: const EdgeInsets.all(20.0),
        minimumSize: const Size(70, 70),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 24,
          color: Colors.white, // Chiffres en blanc
          fontWeight: FontWeight.bold,
        ),
      ),
    );
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
    return GestureDetector(
      onTap: () {
        // Arrêter l'audio et masquer le clavier si l'utilisateur clique n'importe où sur l'écran
        if (_isAudioPlaying || _isKeypadVisible) {
          _hideNumericKeypad();
        }
      },
      child: Scaffold(
        backgroundColor: neutralWhite,

        body: Stack(
          children: [
            SafeArea(
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
                                // Texte sous l'icône
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
            // Clavier numérique personnalisé
            if (_isKeypadVisible)
              GestureDetector(
                onTap: _hideNumericKeypad,
                child: Container(
                  color: Colors.black54,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {}, // Empêche la fermeture lors du tap sur le clavier
                      child: _buildNumericKeypad(),
                    ),
                  ),
                ),
              ),
          ],
        ),

        // Icône vocale déplacée en bas à gauche
        floatingActionButton: Container(
          margin: const EdgeInsets.only(left: 16, bottom: 80), // Positionné au-dessus de la navbar
          child: VocalIcon(
            onPressed: () {
              // Lire l'audio du clavier numérique en boucle
              if (!_isAudioPlaying) {
                _playClavierAudioLoop();
              } else {
                _hideNumericKeypad();
              }
            },
            isActive: _isAudioPlaying,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,

        // Barre de navigation inférieure
        bottomNavigationBar: BottomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
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