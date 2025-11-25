import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musso_deme_app/constants/assets.dart'; // Ajout de l'import pour les assets
import 'package:musso_deme_app/pages/Notifications.dart';
import 'package:musso_deme_app/wingets/CustomAudioPlayerBar.dart';

const Color primaryViolet = Color(0xFF491B6D);
const Color lightViolet = Color(0xFFEAE1F4);
const Color neutralWhite = Colors.white;

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  late AudioPlayer _audioPlayer; // Ajout du lecteur audio
  bool _isPlayingAudio = false; // État de lecture de l'audio

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _playNutritionAudio(); // Lecture de l'audio de nutrition au démarrage
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Libération des ressources audio
    super.dispose();
  }

  // Lecture de l'audio de nutrition
  Future<void> _playNutritionAudio() async {
    try {
      await _audioPlayer.setAsset(AppAssets.audioConseilNutrition);
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
      print('Erreur lors de la lecture de l\'audio de nutrition: $e');
    }
  }

  // Widget d'une carte (titre, description, icône + bouton play)
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
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: lightViolet,
              ),
              child: Icon(icon, color: primaryViolet, size: 30),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
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
              style: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontSize: 11,
              ),
            ),
            const Spacer(),
            // bouton play rond
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: onPlay,
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: primaryViolet.withOpacity(0.15)),
                    color: lightViolet,
                  ),
                  child: Icon(Icons.play_arrow, color: primaryViolet),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final headerHeight = 72.0;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Contenu principal scrollable
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120), // espace pour le player en bas
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bandeau titre
                  Container(
                    height: headerHeight,
                    decoration: BoxDecoration(
                      color: primaryViolet,
                      borderRadius: const BorderRadius.only(
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
                        Expanded(
                          child: Text(
                            'Tout savoir sur la nutrition',
                            style: const TextStyle(
                              color: neutralWhite,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
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
                          icon: const Icon(Icons.notifications_none, color: neutralWhite),
                        ),
                        // Bouton pour lire l'audio de nutrition
                        IconButton(
                          onPressed: _playNutritionAudio,
                          icon: Icon(
                            _isPlayingAudio ? Icons.pause : Icons.volume_up,
                            color: neutralWhite,
                          ),
                        ),

                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Bloc Intro (fond violet clair, illustration à droite)
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
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Decouvrir comment bien nourrir\nles enfants avec les produits de la region.",
                                  style: TextStyle(
                                    color: primaryViolet,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton.icon(
                                  onPressed: _playNutritionAudio, // Lecture de l'audio de nutrition
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryViolet,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  icon: Icon(_isPlayingAudio ? Icons.pause : Icons.play_arrow),
                                  label: Text(_isPlayingAudio ? 'En cours de lecture...' : 'Intro'),
                                ),
                              ],
                            ),
                          ),
                          // illustration
                          SizedBox(
                            width: 84,
                            height: 84,
                            child: Image.asset('assets/images/gouverne copy.png', fit: BoxFit.contain),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Grid des 4 cartes (2x2)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 16,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 0.86,
                      children: [
                        _buildCard(
                          title: 'Bien manger\nchaque jour',
                          subtitle: 'Repas équilibré avec les produits locaux',
                          icon: Icons.restaurant,
                          onPlay: () {
                            // correspond à _tracks[1]
                            // _playTrackByCardIndex(0);
                          }
                        ),
                        _buildCard(
                          title: 'Alimentation\ndes enfants',
                          subtitle: 'Biens nutritionnels par âge',
                          icon: Icons.child_care,
                          onPlay: () {
                            // _tracks[2]
                            // _playTrackByCardIndex(1);
                          }
                        ),
                        _buildCard(
                          title: 'Bien être des\nnouveaux nés',
                          subtitle: 'Nutriments essentiels pour bébé et la maman',
                          icon: Icons.add_circle,
                          onPlay: () {
                            // _tracks[3]
                            // _playTrackByCardIndex(2);
                          }
                        ),
                        _buildCard(
                          title: 'L’eau et l’hygiène\nalimentaire',
                          subtitle: "Importance de potable et l'hygiène",
                          icon: Icons.water_drop,
                          onPlay: () {
                            // _tracks[4]
                            // _playTrackByCardIndex(3);
                          }
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomAudioPlayerBar(),
    );
  }
}