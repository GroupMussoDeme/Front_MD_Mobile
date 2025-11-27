// lib/pages/FinancialAidScreen.dart
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musso_deme_app/utils/navigation_utils.dart';
import 'package:musso_deme_app/widgets/BottomNavBar.dart';
import 'package:musso_deme_app/pages/Formations.dart';
import 'package:musso_deme_app/pages/ProfileScreen.dart';

import 'DetailsSurMicroCredit.dart';
import 'appel_screen.dart';

import 'package:musso_deme_app/models/institution.dart';
import 'package:musso_deme_app/services/institution_api_service.dart';
import 'package:musso_deme_app/widgets/VocalIcon.dart';

// --- Couleurs charte ---
const Color primaryViolet = Color(0xFF491B6D);
const Color neutralWhite = Colors.white;
const Color lightGrey = Color(0xFFF0F0F0);
const Color darkGrey = Color(0xFF707070);

class FinancialAidScreen extends StatefulWidget {
  const FinancialAidScreen({super.key});

  @override
  State<FinancialAidScreen> createState() => _FinancialAidScreenState();
}

class _FinancialAidScreenState extends State<FinancialAidScreen> {
  int _selectedIndex = 0;
  late Future<List<InstitutionFinanciere>> _futureInstitutions;
  late AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    _playAudio();
    _futureInstitutions = InstitutionApiService.fetchInstitutions();
  }

  void _playAudio() async {
    try {
      // Lecture automatique de l'audio "insttution financiere.aac"
      await Future.delayed(const Duration(milliseconds: 500)); // Petit délai avant de commencer
      await audioPlayer.setAsset("assets/audios/insttution financiere.aac");
      await audioPlayer.play();
    } catch (e) {
      print("Erreur lors de la lecture de l'audio: $e");
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (index == 0) {
        // Home
        navigateToHome(context);
      } else if (index == 1) {
        // Formations
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
                      IconButton(
                        icon: const Icon(
                          Icons.notifications_none,
                          color: neutralWhite,
                        ),
                        onPressed: () {},
                      ),
                      VocalIcon(
                        onPressed: () {
                          // TODO: Implémenter la fonctionnalité vocale
                        },
                        isActive: true,
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
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 15.0,
              ),
              child: FutureBuilder<List<InstitutionFinanciere>>(
                future: _futureInstitutions,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Erreur lors du chargement des institutions : ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  final institutions = snapshot.data ?? [];
                  if (institutions.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        "Aucune institution trouvée pour le moment.",
                        style: TextStyle(color: primaryViolet),
                      ),
                    );
                  }

                  return Column(
                    children: institutions.map((inst) {
                      return FinancialInstitutionCard(
                        institution: inst,
                        onVoirPlus: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MicrocreditDetailsScreen(institution: inst),
                            ),
                          );
                        },
                        onCall: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AppelScreen(institution: inst),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

// ----------------------------------------------------------------------
// Carte institution – basée sur les données du backend
// ----------------------------------------------------------------------
class FinancialInstitutionCard extends StatelessWidget {
  final InstitutionFinanciere institution;
  final VoidCallback onVoirPlus;
  final VoidCallback onCall;

  const FinancialInstitutionCard({
    super.key,
    required this.institution,
    required this.onVoirPlus,
    required this.onCall,
  });

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
              Icon(
                icon,
                color: isPrimary ? neutralWhite : primaryViolet,
                size: 20,
              ),
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
    final String amountRange;
    if (institution.montantMin != null && institution.montantMax != null) {
      amountRange =
          'De ${institution.montantMin!.toStringAsFixed(0)} FC à ${institution.montantMax!.toStringAsFixed(0)} FC';
    } else {
      amountRange = 'Montant à voir avec la caisse';
    }

    final String sectors = institution.secteurActivite?.isNotEmpty == true
        ? institution.secteurActivite!
        : 'Secteurs à préciser avec la caisse';

    final String rate = institution.tauxInteret?.isNotEmpty == true
        ? institution.tauxInteret!
        : 'Taux non renseigné';

    // Gestion du logo (assets ou backend)
    Widget buildLogo() {
      final fullLogoUrl = InstitutionApiService.fileUrl(institution.logoUrl);
      debugPrint(
        'Logo institution ${institution.nom} '
        'brut="${institution.logoUrl}" -> complet="$fullLogoUrl"',
      );

      return Image.network(
        fullLogoUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, error, ___) {
          debugPrint('Erreur network logo: $fullLogoUrl | error=$error');
          return Center(
            child: Text(
              institution.nom.substring(0, 1),
              style: const TextStyle(
                color: primaryViolet,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      );
    }

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
          // Ligne 1: logo + infos
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: lightGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: buildLogo(),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      institution.nom,
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
                      sectors,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
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

          // Ligne 2: actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                icon: Icons.volume_up_outlined,
                label: 'Écouter',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Audio non encore disponible.'),
                    ),
                  );
                },
                isPrimary: false,
              ),
              _buildActionButton(
                label: 'Voir plus',
                onTap: onVoirPlus,
                isPrimary: true,
              ),
              IconButton(
                icon: const Icon(
                  Icons.favorite_border,
                  color: darkGrey,
                  size: 28,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(
                  Icons.call_outlined,
                  color: darkGrey,
                  size: 28,
                ),
                onPressed: onCall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
