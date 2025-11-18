import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musso_deme_app/pages/Notifications.dart';

const Color primaryViolet = Color(0xFF491B6D);
const Color lightViolet = Color(0xFFEAE1F4);
const Color neutralWhite = Colors.white;

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  late final AudioPlayer _player;
  // playlist: ordre logique (Intro, carte1, carte2, carte3, carte4)
  final List<String> _tracks = [
    'assets/audio/intro.mp3',
    'assets/audio/bien_manger.mp3',
    'assets/audio/alimentation_enfants.mp3',
    'assets/audio/bien_etre_nouveaux_nes.mp3',
    'assets/audio/eau_hygiene.mp3',
  ];

  // index courant dans _tracks
  int _currentIndex = 0;

  // informations pour afficher position/duration
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _loadIndex(_currentIndex);

    // écouteurs
    _player.playerStateStream.listen((state) {
      setState(() {
        _isPlaying = state.playing;
      });
    });

    _player.durationStream.listen((d) {
      setState(() {
        _duration = d ?? Duration.zero;
      });
    });

    _player.positionStream.listen((p) {
      setState(() {
        _position = p;
      });
    });

    _player.processingStateStream.listen((proc) {
      if (proc == ProcessingState.completed) {
        // auto passer à la piste suivante s'il y en a
        _onNext();
      }
    });
  }

  Future<void> _loadIndex(int index) async {
    // charge le fichier de l'index sans lancer
    try {
      await _player.setAsset(_tracks[index]);
      setState(() {
        _currentIndex = index;
      });
    } catch (e) {
      debugPrint('Erreur chargement audio: $e');
    }
  }

  String _formatDuration(Duration d) {
    final mm = (d.inMinutes).toString().padLeft(2, '0');
    final ss = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  void _onPlayPause() {
    if (_player.playing) {
      _player.pause();
    } else {
      _player.play();
    }
  }

  Future<void> _onNext() async {
    final next = (_currentIndex + 1) % _tracks.length;
    await _loadIndex(next);
    await _player.play();
  }

  Future<void> _onPrev() async {
    final prev = (_currentIndex - 1) < 0 ? _tracks.length - 1 : _currentIndex - 1;
    await _loadIndex(prev);
    await _player.play();
  }

  Future<void> _seekTo(double relative) async {
    final newPos = _duration * relative;
    await _player.seek(newPos);
  }

  // Quand l'utilisateur clique sur le play d'une carte
  Future<void> _playTrackByCardIndex(int cardIndex) async {
    // cardIndex correspond aux cartes, mais la playlist contient intro en index 0
    final songIndex = cardIndex + 1; // cartes commencent à 1 dans _tracks
    await _loadIndex(songIndex);
    await _player.play();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
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
                                  onPressed: () async {
                                    // lance l'intro (index 0)
                                    await _loadIndex(0);
                                    await _player.play();
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
                            child: Image.asset('assets/images/illustration_maman.png', fit: BoxFit.contain),
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
                          onPlay: () => _playTrackByCardIndex(0), // correspond à _tracks[1]
                        ),
                        _buildCard(
                          title: 'Alimentation\ndes enfants',
                          subtitle: 'Biens nutritionnels par âge',
                          icon: Icons.child_care,
                          onPlay: () => _playTrackByCardIndex(1), // _tracks[2]
                        ),
                        _buildCard(
                          title: 'Bien être des\nnouveaux nés',
                          subtitle: 'Nutriments essentiels pour bébé et la maman',
                          icon: Icons.add_circle,
                          onPlay: () => _playTrackByCardIndex(2), // _tracks[3]
                        ),
                        _buildCard(
                          title: 'L’eau et l’hygiène\nalimentaire',
                          subtitle: "Importance de potable et l'hygiène",
                          icon: Icons.water_drop,
                          onPlay: () => _playTrackByCardIndex(3), // _tracks[4]
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),

            // Player flottant en bas (positionné)
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: primaryViolet,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8, offset: const Offset(0, 3)),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // progress bar
                    Row(
                      children: [
                        Text(
                          _formatDuration(_position),
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onHorizontalDragUpdate: (details) {
                              // calcule une position relative approximative
                              // on ne connait pas la largeur exacte ici, donc utiliser le dx relatif à la largeur via RenderBox
                            },
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                                overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                                trackHeight: 4,
                                activeTrackColor: Colors.white,
                                inactiveTrackColor: Colors.white.withOpacity(0.3),
                                thumbColor: Colors.white,
                              ),
                              child: Slider(
                                min: 0,
                                max: _duration.inMilliseconds > 0 ? _duration.inMilliseconds.toDouble() : 1,
                                value: _position.inMilliseconds.clamp(0, _duration.inMilliseconds > 0 ? _duration.inMilliseconds : 1).toDouble(),
                                onChanged: (value) {
                                  _seekTo(value / (_duration.inMilliseconds > 0 ? _duration.inMilliseconds.toDouble() : 1));
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatDuration(_duration),
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // controles (prev, play/pause, next)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // bouton télécharge (optionnel)
                        IconButton(
                          onPressed: () {
                            // telechargement/logique si nécessaire
                          },
                          icon: const Icon(Icons.download_rounded, color: Colors.white),
                        ),

                        Row(
                          children: [
                            IconButton(
                              onPressed: _onPrev,
                              icon: const Icon(Icons.skip_previous, color: Colors.white, size: 28),
                            ),
                            const SizedBox(width: 6),
                            // play/pause rond
                            GestureDetector(
                              onTap: _onPlayPause,
                              child: Container(
                                width: 62,
                                height: 62,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: primaryViolet,
                                  size: 36,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            IconButton(
                              onPressed: _onNext,
                              icon: const Icon(Icons.skip_next, color: Colors.white, size: 28),
                            ),
                          ],
                        ),

                        // durée droite / repeat ou autre
                        IconButton(
                          onPressed: () {
                            // exemple : repeat toggle ou ouvrir playlist
                          },
                          icon: const Icon(Icons.repeat, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
