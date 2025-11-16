import 'package:flutter/material.dart';

class BienvenuePage extends StatelessWidget {
  const BienvenuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/welcome_background.jpg'), 
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Purple header with text and microphone icon
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 200,
              child: Container(
                color: Colors.deepPurple,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'BIENVENUE SUR MUSSO DEME', // Correction de la faute de frappe
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Icon(
                      Icons.mic,
                      color: Colors.white,
                      size: 50,
                    ),
                  ],
                ),
              ),
            ),
            
            // Optional: Add any additional content below the header
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Text(
                'Bienvenue dans l\'application Musso Deme !', // Correction ici aussi
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}