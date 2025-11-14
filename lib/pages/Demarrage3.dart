import 'package:flutter/material.dart';

class Demarrage3 extends StatefulWidget {
  const Demarrage3({super.key});

  @override
  _Demarrage3State createState() => _Demarrage3State();
}

class _Demarrage3State extends State<Demarrage3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background3.jpg'), // Replace with your background image
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Centered logo - this will be an image that can be changed later
            Positioned(
              top: 150,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/images/logo.png', // This can be changed later
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
            
            // Next button (arrow) - this will navigate to the welcome page
            Positioned(
              bottom: 60,
              right: 20,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/Bienvenue');
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
                  SizedBox(width: 5),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.white,
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