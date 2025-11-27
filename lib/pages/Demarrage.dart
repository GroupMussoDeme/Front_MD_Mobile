import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musso_deme_app/pages/Demarrage2.dart';
import 'package:musso_deme_app/widgets/CustomNextButton.dart'; // Import du bouton personnalisé

class Demarrage extends StatefulWidget {
  const Demarrage({super.key});

  @override
  _DemarrageState createState() => _DemarrageState();
}

class _DemarrageState extends State<Demarrage> {
  late PageController _pageController;
  late AudioPlayer audioPlayer; // Instance de AudioPlayer
  bool _isPlaying = false; // Indicateur pour savoir si la lecture est en cours

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    audioPlayer = AudioPlayer();
    _playAudio(); // Lecture de l'audio
    
    // La navigation automatique est maintenant gérée par la fin de la lecture vocale
  }
  
  // Lecture de l'audio
  void _playAudio() async {
    try {
      // Gestionnaires d'événements
      audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            _isPlaying = false;
          });
          // Navigation vers la page suivante lorsque la lecture est terminée
          _navigateToNextPage();
        }
      });
      
      // Arrêter toute lecture en cours
      await audioPlayer.stop();
      
      // Lecture automatique de l'audio "Bienvenue.aac" au démarrage
      await audioPlayer.setAsset("assets/audios/Bienvenue.aac");
      setState(() {
        _isPlaying = true;
      });
      await audioPlayer.play();
    } catch (e) {
      setState(() {
        _isPlaying = false;
      });
      // En cas d'erreur, on navigue quand même vers la page suivante
      _navigateToNextPage();
      print("Erreur lors de la lecture de l'audio: $e");
    }
  }
  
  // Navigation vers la page suivante avec animation
  void _navigateToNextPage() {
    // Animation de droite à gauche
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => Demarrage2(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
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
    audioPlayer.dispose(); // Arrêter la lecture audio lors de la destruction
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFC983DE), 
        ),
        child: Stack(
          children: [
            // Logo centré
            Positioned(
              top: MediaQuery.of(context).size.height / 2 - 150, // Centrer verticalement
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/images/logo.png',
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),
            ),
            
            // Haut-parleur en bas du logo
            Positioned(
              top: MediaQuery.of(context).size.height / 2 + 180, // Positionné sous le logo
              left: 0,
              right: 0,
              child: Icon(
                Icons.volume_up, // Icône de haut-parleur
                color: Colors.white,
                size: 60,
              ),
            ),
            
            // Points 
            Positioned(
              bottom: 60,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 5),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 5),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            
            // Bouton Next personnalisé en bas à droite
            Positioned(
              bottom: 60,
              right: 20,
              child: CustomNextButton(
                onPressed: () {
                  // Navigation immédiate si l'utilisateur clique sur le bouton
                  _navigateToNextPage();
                },
              ),
            ),
            
            // Bouton de test audio en haut à droite
            Positioned(
              top: 50,
              right: 20,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/TestAudio');
                },
                child: Text('Test Audio'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}