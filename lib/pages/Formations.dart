import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musso_deme_app/pages/HomeScreen.dart';
import 'package:musso_deme_app/models/contenu.dart';
import 'package:musso_deme_app/services/media_api_service.dart';
import 'package:musso_deme_app/utils/navigation_utils.dart';
import 'package:musso_deme_app/widgets/BottomNavBar.dart';
import 'package:musso_deme_app/widgets/TutorialVideoCard.dart';
import 'package:musso_deme_app/widgets/VocalIcon.dart';

import 'full_screen_video_page.dart'; // voir section 3 ci-dessous

const Color kPrimaryPurple = Color(0xFF491B6D);

class FormationVideosPage extends StatefulWidget {
  const FormationVideosPage({super.key});

  @override
  State<FormationVideosPage> createState() => _FormationVideosPageState();
}

class _FormationVideosPageState extends State<FormationVideosPage> {
  int _selectedIndex = 1;
  late AudioPlayer audioPlayer;

  late Future<List<Contenu>> _futureVideos;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    _playAudio();
    _futureVideos = MediaApiService.fetchContenus(
      typeInfo: 'VIDEO_FORMATION',
      typeCategorie: 'VIDEOS',
    );
  }

  void _playAudio() async {
    try {
      // Lecture automatique de l'audio "formation.aac"
      await audioPlayer.setAsset("assets/audios/formation.aac");
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
    setState(() => _selectedIndex = index);

    if (index == 0) {
      // Accueil
      navigateToHome(context);
    } else if (index == 1) {
      // Formation -> on est déjà dessus
      return;
    } else if (index == 2) {
      // Profil (si tu as une page profil, remplace ici)
      // Navigator.push(...);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FutureBuilder<List<Contenu>>(
                  future: _futureVideos,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Erreur lors du chargement des vidéos : ${snapshot.error}",
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    final videos = snapshot.data ?? [];
                    if (videos.isEmpty) {
                      return const Center(
                        child: Text(
                          "Aucun tuto vidéo pour le moment.",
                          style: TextStyle(
                            color: kPrimaryPurple,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: videos.length,
                      itemBuilder: (context, index) {
                        final contenu = videos[index];
                        final videoUrl = MediaApiService.fileUrl(
                          contenu.urlContenu,
                        );

                        return TutorialVideoCard(
                          title: contenu.titre ?? 'Titre indisponible',
                          duration: (contenu.duree ?? '').isNotEmpty
                              ? contenu.duree!
                              : '56 min', // valeur par défaut
                          videoUrl: videoUrl ?? '',
                          onOpenFullScreen: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FullScreenVideoPage(
                                  videoUrl: videoUrl ?? '',
                                  title: contenu.titre ?? 'Vidéo',
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
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: const BoxDecoration(
        color: kPrimaryPurple,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 26),
          ),
          const Expanded(
            child: Text(
              "Tutos",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          VocalIcon(
            onPressed: () {
              // TODO: Implémenter la fonctionnalité vocale
            },
            isActive: true,
          ),
        ],
      ),
    );
  }
}
