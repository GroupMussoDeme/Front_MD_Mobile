import 'package:flutter/material.dart';
import 'package:musso_deme_app/pages/Demarrage3.dart';
import 'package:musso_deme_app/wingets/CustomNextButton.dart'; // Import du bouton personnalisé

class Demarrage2 extends StatefulWidget {
  const Demarrage2({super.key});

  @override
  _Demarrage2State createState() => _Demarrage2State();
}

class _Demarrage2State extends State<Demarrage2> {
  @override
  void initState() {
    super.initState();
    
    // Navigation automatique toutes les 3 secondes
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        // Animation de droite à gauche
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => Demarrage3(),
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background2.jpg'), 
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
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
                          color: Colors.white.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 5),
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
                  // Animation de droite à gauche
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => Demarrage3(),
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}