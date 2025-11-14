import 'package:flutter/material.dart';

const Color primaryViolet = Color(0xFF491B6D);
const Color neutralWhite = Colors.white;

class PrimaryHeader extends StatelessWidget {
  final Widget logoChild; 

  const PrimaryHeader({
    super.key,
    required this.logoChild, 
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    const double headerHeight = 100.0; 

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: screenWidth,
          height: headerHeight,
          color: primaryViolet,
        ),

        // 2. Le cercle de profil/logo
        Positioned(
          // Centré horizontalement
          left: 0,
          right: 0,
          // Positionné pour que le cercle déborde
          top: headerHeight - 45 - 4, 
          child: Center(
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: neutralWhite,
                shape: BoxShape.circle,
                border: Border.all(color: primaryViolet, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              // --- Insertion du logo (Image) directement ---
              child: ClipOval( // Assurez-vous que l'image est bien coupée en cercle
                child: logoChild,
              ),
              // ------------------------------------------
            ),
          ),
        ),
      ],
    );
  }
}