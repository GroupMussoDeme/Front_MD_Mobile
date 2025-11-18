import 'package:flutter/material.dart';
import 'package:musso_deme_app/pages/Demarrage2.dart';
import 'package:musso_deme_app/pages/Demarrage3.dart';
import 'package:flutter_tts/flutter_tts.dart'; // Import du package TTS
import 'package:musso_deme_app/wingets/CustomNextButton.dart'; // Import du bouton personnalisé

class Demarrage extends StatefulWidget {
  const Demarrage({super.key});

  @override
  _DemarrageState createState() => _DemarrageState();
}

class _DemarrageState extends State<Demarrage> {
  late PageController _pageController;
  late FlutterTts flutterTts; // Instance de FlutterTts
  bool _isSpeaking = false; // Indicateur pour savoir si la lecture est en cours

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initTts(); // Initialisation du TTS
    
    // La navigation automatique est maintenant gérée par la fin de la lecture vocale
  }
  
  // Initialisation du TTS
  void _initTts() async {
    flutterTts = FlutterTts();
    
    // Configuration de la langue en bambara (bamanankan)
    await flutterTts.setLanguage("bm"); // bm est le code ISO pour le bambara
    
    // Configuration d'une voix féminine si disponible
    await flutterTts.setVoice({"name": "bm-ML-language", "locale": "bm-ML"});
    
    // Réglage du pitch (hauteur) un peu plus élevé pour une voix féminine
    await flutterTts.setPitch(1.2);
    
    // Réglage de la vitesse de parole (0.5 = plus lent, pour une meilleure compréhension)
    await flutterTts.setSpeechRate(0.5);
    
    // Gestionnaires d'événements
    flutterTts.setStartHandler(() {
      setState(() {
        _isSpeaking = true;
      });
    });
    
    flutterTts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false;
      });
      // Navigation vers la page suivante lorsque la lecture est terminée
      _navigateToNextPage();
    });
    
    flutterTts.setErrorHandler((msg) {
      setState(() {
        _isSpeaking = false;
      });
      // En cas d'erreur, on navigue quand même vers la page suivante
      _navigateToNextPage();
    });
    
    // Lecture automatique du message traduit en bamanankan au démarrage avec une voix féminine
    await flutterTts.speak("I BISSIMILAH MUSODEME SANFE! NIN APPLI NIN FEMMES WERI KAN JATIGUIYE DON. SABABU NI O YIRESE, NI O BAGA WERI KAN JATIGUIYE, SABABU NI O SE KAN JATIGUIYE. I BE SE KOMA COMPTE I JEN!");
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
    flutterTts.stop(); // Arrêter la lecture TTS lors de la destruction
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
          ],
        ),
      ),
    );
  }
}