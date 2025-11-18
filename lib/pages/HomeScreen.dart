import 'package:flutter/material.dart';
import 'package:musso_deme_app/ConseilNouvelleMaman.dart';
import 'package:musso_deme_app/pages/AudioContentScreen.dart';
import 'package:musso_deme_app/pages/DroitsDesEnfants.dart';
import 'package:musso_deme_app/pages/DroitsDesFemmes.dart';
import 'package:musso_deme_app/pages/NutritionScreen.dart';
import 'package:musso_deme_app/pages/FinancialAidScreen.dart';
import 'package:musso_deme_app/pages/RuralMarketScreen.dart';
import 'package:musso_deme_app/pages/Formations.dart';
import 'package:musso_deme_app/pages/cooperative_page.dart';
import 'package:musso_deme_app/wingets/BottomNavBar.dart';

// --- Définition des couleurs principales ---
const Color primaryViolet = Color(0xFF491B6D);
const Color lightViolet = Color(0xFFEAE1F4);
const Color neutralWhite = Colors.white;
const Color darkGrey = Color(0xFF707070);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

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
    });
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
                  // Icône notification
                  Positioned(
                    right: 15,
                    top: 10,
                    child: IconButton(
                      icon: const Icon(Icons.notifications_none,
                          color: neutralWhite, size: 28),
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
                  'assets/images/background2.png', // Remplace par ton image
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 150,
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
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const NutritionScreen()));
                            break;
                          case 'Droits des enfants':
                            Navigator.push(context, MaterialPageRoute(builder: (_) => AudioContentScreen(screenTitle: 'Droits des enfants', introMessage: 'Bienvenue dans l\'espace droit des', tracks: childRightsTracks,)));
                            break;
                          case 'Droits des femmes':
                            Navigator.push(context, MaterialPageRoute(builder: (_) => AudioContentScreen(screenTitle: 'Droits des femmes', introMessage: 'Bienvenue dans l\'espace droit des femmes.\nÉcouter vos droits expliques en Bambara.', tracks: womenRightsTracks,)));
                            break;
                          case 'Conseils aux mamans':
                            Navigator.push(context, MaterialPageRoute(builder: (_) => AudioContentScreen(screenTitle: 'Conseils aux mamans', introMessage: 'Bienvenue dans l\'espace santé de la femmes.\nÉcouter des conseils sur la santé en Bambara.', tracks: newMomsAdviceTracks,)));
                            break;
                          case 'Marchés':
                            Navigator.push(context, MaterialPageRoute(builder: (_) => RuralMarketScreen()));
                            break;
                          case 'Aides aux financements':
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const FinancialAidScreen()));
                            break;
                          case 'Formations':
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const FormationVideosPage()));
                            break;
                          case 'Coopératives':
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const CooperativePage()));
                            break;
                          default:
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => TopicPage(title: title)),
                            );
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: lightViolet,
                            ),
                            child: Icon(
                              item['icon'],
                              color: primaryViolet,
                              size: 35,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['title'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: primaryViolet,
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
      appBar: AppBar(
        backgroundColor: primaryViolet,
        title: Text(title),
      ),
      body: Center(
        child: Text(
          "Page : $title",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
