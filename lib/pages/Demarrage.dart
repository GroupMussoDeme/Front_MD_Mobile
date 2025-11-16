import 'package:flutter/material.dart';
import 'package:musso_deme_app/pages/Demarrage2.dart';

class Demarrage extends StatefulWidget {
  const Demarrage({super.key});

  @override
  _DemarrageState createState() => _DemarrageState();
}

class _DemarrageState extends State<Demarrage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFC983DE), // Couleur C983DE au lieu de l'image
        ),
        child: Stack(
          children: [          
            Positioned(
              top: 150,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/images/logo.png', 
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
            
            // Skip button
            Positioned(
              bottom: 60,
              left: 20,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/Bienvenue');
                },
                child: Text('Skip'),
              ),
            ),
            
            // Next button (arrow)
            Positioned(
              bottom: 60,
              right: 20,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Demarrage2()));
                },
                child: Icon(Icons.arrow_forward),
              ),
            ),
            
            // Page indicator dots
            Positioned(
              bottom: 100,
              left: 20,
              child: Row(
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
            ),
          ],
        ),
      ),
    );
  }
}