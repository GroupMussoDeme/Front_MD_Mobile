import 'package:flutter/material.dart';
import 'package:musso_deme_app/pages/Demarrage2.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musso_deme_app/constants/assets.dart';
import 'package:musso_deme_app/wingets/CustomNextButton.dart';

class Demarrage extends StatefulWidget {
  const Demarrage({super.key});

  @override
  _DemarrageState createState() => _DemarrageState();
}

class _DemarrageState extends State<Demarrage> {
  late PageController _pageController;
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _audioPlayer = AudioPlayer();
    _playWelcomeAudio();
  }

  /// 🔊 Lecture de l'audio de bienvenue
  void _playWelcomeAudio() async {
    try {
      await _audioPlayer.setAsset(AppAssets.audioBienvenue);
      setState(() => _isPlaying = true);
      
      // Jouer l'audio
      await _audioPlayer.play();
      
      // Naviguer vers la page suivante une fois l'audio terminé
      _audioPlayer.playerStateStream.firstWhere(
        (state) => state.processingState == ProcessingState.completed,
      ).then((_) {
        if (mounted) {
          setState(() => _isPlaying = false);
          _navigateToNextPage();
        }
      });
    } catch (e) {
      print('Erreur lors de la lecture de l\'audio de bienvenue: $e');
      // En cas d'erreur, naviguer quand même vers la page suivante
      _navigateToNextPage();
    }
  }

  ///  Navigation automatique vers Demarrage2 après la voix
  void _navigateToNextPage() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => Demarrage2(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          var tween = Tween(begin: begin, end: end);
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFC983DE),
        ),
        child: Stack(
          children: [
            ///  Logo centré
            Positioned(
              top: MediaQuery.of(context).size.height / 2 - 150,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/images/logo.png',
                width: 300,
                height: 300,
              ),
            ),

            /// 🔊 Haut-parleur animé si la voix parle
            Positioned(
              top: MediaQuery.of(context).size.height / 2 + 180,
              left: 0,
              right: 0,
              child: Icon(
                Icons.volume_up,
                color: _isPlaying ? Colors.yellow : Colors.white,
                size: 60,
              ),
            ),

            /// 🔵 Points + "Skip"
            Positioned(
              bottom: 60,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildDot(active: true),
                      const SizedBox(width: 5),
                      _buildDot(),
                      const SizedBox(width: 5),
                      _buildDot(),
                    ],
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: _navigateToNextPage,
                    child: const Text(
                      'Skip',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                ],
              ),
            ),

            /// 👉 Bouton Next
            Positioned(
              bottom: 60,
              right: 20,
              child: CustomNextButton(
                onPressed: _navigateToNextPage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget pour les petits points
  Widget _buildDot({bool active = false}) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: active ? Colors.white : Colors.white.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
    );
  }
}
