import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musso_deme_app/pages/Notifications.dart';
import 'package:musso_deme_app/wingets/CustomAudioPlayerBar.dart';
import 'package:musso_deme_app/services/audio_service.dart'; // Import du service audio
import 'package:provider/provider.dart'; // Import de provider

const Color primaryViolet = Color(0xFF491B6D);
const Color lightViolet = Color(0xFFEAE1F4);
const Color neutralWhite = Colors.white;

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _playAudio(int index) async {
    try {
      final audioService = Provider.of<AudioService>(context, listen: false);
      // Charger le fichier audio depuis les assets (utiliser le fichier WAV qui fonctionne)
      await audioService.playAudio('assets/audios/test.wav', index);
      
      // Afficher un message de succès
      print('Lecture de l\'audio démarrée pour l\'index: $index');
    } catch (e) {
      print('Erreur lors de la lecture audio: $e');
      // Afficher un message d'erreur à l'utilisateur avec plus de détails
      String errorMessage = 'Erreur lors de la lecture audio';
      if (e is Exception) {
        errorMessage = e.toString();
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
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
    final audioService = Provider.of<AudioService>(context);
    
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
                            overflow: TextOverflow.ellipsis, // Gérer le débordement avec des points de suspension
                            maxLines: 1, // Limiter à une seule ligne
                            textAlign: TextAlign.center, // Centrer le texte
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
                                  onPressed: () {
                                    // lance l'intro (index 0)
                                    _playAudio(0);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryViolet,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  icon: const Icon(Icons.play_arrow),
                                  label: const Text('Intro'),
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
                            _playAudio(1);
                          }
                        ),
                        _buildCard(
                          title: 'Alimentation\ndes enfants',
                          subtitle: 'Biens nutritionnels par âge',
                          icon: Icons.child_care,
                          onPlay: () {
                            // _tracks[2]
                            _playAudio(2);
                          }
                        ),
                        _buildCard(
                          title: 'Bien être des\nnouveaux nés',
                          subtitle: 'Nutriments essentiels pour bébé et la maman',
                          icon: Icons.add_circle,
                          onPlay: () {
                            // _tracks[3]
                            _playAudio(3);
                          }
                        ),
                        _buildCard(
                          title: 'L’eau et l’hygiène\nalimentaire',
                          subtitle: "Importance de potable et l'hygiène",
                          icon: Icons.water_drop,
                          onPlay: () {
                            // _tracks[4]
                            _playAudio(4);
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
      bottomNavigationBar: CustomAudioPlayerBar(player: audioService.player), // Passer l'instance du lecteur
    );
  }
}