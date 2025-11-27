import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musso_deme_app/pages/Notifications.dart';
import 'package:musso_deme_app/models/contenu.dart';
import 'package:musso_deme_app/widgets/CustomAudioPlayerBar.dart';
import 'package:musso_deme_app/services/audio_service.dart';
import 'package:musso_deme_app/services/media_api_service.dart';
import 'package:musso_deme_app/widgets/VocalIcon.dart';
import 'package:provider/provider.dart';

const Color primaryViolet = Color(0xFF491B6D);
const Color lightViolet = Color(0xFFEAE1F4);
const Color neutralWhite = Colors.white;

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  late Future<List<Contenu>> _futureNutritions;
  late AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    _playAudio();
    _futureNutritions = MediaApiService.fetchContenus(
      typeInfo: 'NUTRITION',
      typeCategorie: 'AUDIOS',
    );
  }

  void _playAudio() async {
    try {
      // Lecture automatique de l'audio "conseil nutrition.aac"
      await Future.delayed(const Duration(milliseconds: 500)); // Petit délai avant de commencer
      await audioPlayer.setAsset("assets/audios/conseil nutrition.aac");
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

  Future<void> _playContenu(Contenu contenu, int index) async {
    try {
      final audioService = Provider.of<AudioService>(context, listen: false);
      final fullUrl = MediaApiService.fileUrl(contenu.urlContenu);

      await audioService.playFromUrl(fullUrl, index);
      debugPrint('Lecture audio depuis backend: $fullUrl');
    } catch (e) {
      debugPrint('Erreur lors de la lecture audio: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur de lecture audio : $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onPlay,
  }) {
    return GestureDetector(
      onTap: onPlay,
      child: Container(
        decoration: BoxDecoration(
          color: neutralWhite,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: lightViolet,
              ),
              child: Icon(icon, color: primaryViolet, size: 30),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: primaryViolet,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontSize: 11,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: onPlay,
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: primaryViolet.withOpacity(0.15)),
                  color: lightViolet,
                ),
                child: const Icon(Icons.play_arrow, color: primaryViolet),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final audioService = Provider.of<AudioService>(context);
    const headerHeight = 72.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    height: headerHeight,
                    decoration: const BoxDecoration(
                      color: primaryViolet,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(18),
                        bottomRight: Radius.circular(18),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back, color: neutralWhite),
                        ),
                        const SizedBox(width: 4),
                        const Expanded(
                          child: Text(
                            'Tout savoir sur la nutrition',
                            style: TextStyle(
                              color: neutralWhite,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NotificationsScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.notifications_none,
                              color: neutralWhite),
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

                  const SizedBox(height: 16),

                  // Bloc Intro
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: lightViolet,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Découvrir comment bien nourrir\nles enfants avec les produits de la région.",
                                  style: TextStyle(
                                    color: primaryViolet,
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 84,
                            height: 84,
                            child: Image.asset(
                              'assets/images/gouverne copy.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Grid audios backend
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: FutureBuilder<List<Contenu>>(
                      future: _futureNutritions,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (snapshot.hasError) {
                          return Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'Erreur lors du chargement des audios : ${snapshot.error}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }

                        final contenus = snapshot.data ?? [];
                        if (contenus.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              "Aucun audio de nutrition disponible pour le moment.",
                              style: TextStyle(color: primaryViolet),
                            ),
                          );
                        }

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: contenus.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.86,
                          ),
                          itemBuilder: (context, index) {
                            final c = contenus[index];
                            return _buildCard(
                              title: c.titre,
                              subtitle: c.description ?? '',
                              icon: Icons.restaurant,
                              onPlay: () => _playContenu(c, index),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomAudioPlayerBar(player: audioService.player),
    );
  }
}
