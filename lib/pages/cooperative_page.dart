import 'package:flutter/material.dart';
import 'package:musso_deme_app/widgets/BottomNavBar.dart';
import 'package:musso_deme_app/pages/GroupChatScreen.dart';
import 'package:musso_deme_app/pages/NewCooperativeScreen.dart';
import 'package:musso_deme_app/utils/navigation_utils.dart';
import 'package:musso_deme_app/pages/Formations.dart';

import 'package:musso_deme_app/models/marche_models.dart';
import 'package:musso_deme_app/services/femme_rurale_api.dart';
import 'package:musso_deme_app/services/auth_service.dart';
import 'package:musso_deme_app/services/session_service.dart';

const Color primaryPurple = Color(0xFF4A0072);
const Color neutralWhite = Colors.white;

// --- Widget de chaque ligne de discussion ----
class CooperativeTile extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final String date;
  final VoidCallback? onTap;

  const CooperativeTile({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.date,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 26,
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
      onTap: onTap,
    );
  }
}

// *****************************************************************
// Page Principale : CooperativePage
// *****************************************************************
class CooperativePage extends StatefulWidget {
  const CooperativePage({super.key});

  @override
  State<CooperativePage> createState() => _CooperativePageState();
}

class _CooperativePageState extends State<CooperativePage> {
  int _selectedIndex = 0;

  late Future<List<Cooperative>> _futureCooperatives;

  @override
  void initState() {
    super.initState();
    _futureCooperatives = _loadCooperatives();
  }

  Future<FemmeRuraleApi> _buildApi() async {
    final token = await SessionService.getAccessToken();
    final userId = await SessionService.getUserId();

    if (token == null || token.isEmpty || userId == null) {
      throw Exception('Session expirée ou utilisateur non connecté');
    }

    return FemmeRuraleApi(
      baseUrl: AuthService.baseUrl,
      token: token,
      femmeId: userId,
    );
  }

  Future<List<Cooperative>> _loadCooperatives() async {
    final api = await _buildApi();
    return api.getMesCooperatives();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: neutralWhite,
      body: Column(
        children: [
          // 1. HEADER
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
                      // Icône de retour
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
                      const Text(
                        "Coopératives",
                        style: TextStyle(
                          color: neutralWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      // Bouton d'ajout (+)
                      Container(
                        decoration: const BoxDecoration(
                          color: primaryPurple,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add,
                              color: neutralWhite, size: 26),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NewCooperativeScreen(),
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

          // 2. Corps : Liste des coopératives (FutureBuilder)
          Expanded(
            child: FutureBuilder<List<Cooperative>>(
              future: _futureCooperatives,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Erreur chargement coopératives : ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                final cooperatives = snapshot.data ?? [];
                if (cooperatives.isEmpty) {
                  return const Center(
                    child: Text('Vous n’avez pas encore de coopératives.'),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: cooperatives.length,
                  itemBuilder: (context, index) {
                    final coop = cooperatives[index];

                    final title = coop.nom.isNotEmpty
                        ? coop.nom
                        : 'Coopérative sans nom';

                    final subtitle = 'Membres : ${coop.nbrMembres}';

                    const date = ''; // pas de date dans le DTO pour l’instant

                    return CooperativeTile(
                      imagePath: 'assets/images/cooperative.png',
                      title: title,
                      subtitle: subtitle,
                      date: date,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GroupChatScreen(
                              cooperativeId: coop.id!,
                              cooperativeNom: coop.nom,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      // 3. FOOTER NAVIGATION
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;

            if (index == 0) {
              navigateToHome(context);
            } else if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FormationVideosPage(),
                ),
              );
            }
            // index 2 : profil, à gérer selon ta logique
          });
        },
      ),
    );
  }
}
