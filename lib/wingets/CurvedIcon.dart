import 'package:flutter/material.dart';
import 'dart:math' as math;

// Couleurs définies
const Color lightViolet = Color(0xFFE9E0F3);
const Color darkViolet = Color(0xFF5A2A82);

/// Widget personnalisé pour une icône circulaire avec texte courbé au-dessus
class CurvedIcon extends StatelessWidget {
  final String text;
  final IconData icon;
  final double size;
  final double textSize;
  final double iconSize;

  const CurvedIcon({
    super.key,
    required this.text,
    required this.icon,
    this.size = 100,
    this.textSize = 12,
    this.iconSize = 40,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Cercle de fond
          Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: lightViolet,
            ),
          ),
          // Icône centrée
          Icon(
            icon,
            color: darkViolet,
            size: iconSize,
          ),
          // Texte courbé en arc juste au-dessus de l'icône
          Positioned(
            top: -size * 0.15,
            left: 0,
            right: 0,
            height: size * 0.3,
            child: CustomPaint(
              painter: CurvedTextPainter(
                text: text,
                radius: size * 0.3, // Rayon ajusté pour être plus proche
                style: TextStyle(
                  fontSize: textSize,
                  fontWeight: FontWeight.w500,
                  color: darkViolet,
                  fontFamily: 'Poppins',
                  letterSpacing: 2.0,
                ),
              ),
              size: Size(size, size * 0.3),
            ),
          ),
        ],
      ),
    );
  }
}

/// Painter personnalisé pour le texte courbé
class CurvedTextPainter extends CustomPainter {
  final String text;
  final double radius;
  final TextStyle style;

  CurvedTextPainter({
    required this.text,
    required this.radius,
    required this.style,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    // Créer un arc de 120 degrés centré en haut
    final arcAngle = 120.0 * math.pi / 180.0; // 120 degrés en radians
    final startAngle = -math.pi / 2 - arcAngle / 2; // Commencer en haut centré
    
    // Calculer l'angle entre chaque lettre
    final anglePerLetter = arcAngle / (text.length + 1);
    
    for (int i = 0; i < text.length; i++) {
      final letter = text[i];
      final letterSpan = TextSpan(text: letter, style: style);
      final letterPainter = TextPainter(
        text: letterSpan,
        textDirection: TextDirection.ltr,
      );
      
      letterPainter.layout();
      
      // Positionner chaque lettre le long de l'arc
      final letterAngle = startAngle + anglePerLetter * (i + 1);
      final letterX = center.dx + radius * math.cos(letterAngle);
      final letterY = center.dy + radius * math.sin(letterAngle);
      
      // Calculer la rotation pour que chaque lettre suive la courbure
      final rotation = letterAngle + math.pi / 2;
      
      // Créer une matrice de transformation pour positionner et orienter la lettre
      final transform = Matrix4.identity()
        ..translate(letterX, letterY)
        ..rotateZ(rotation);
      
      canvas.save();
      canvas.transform(transform.storage);
      
      // Dessiner la lettre centrée sur l'origine
      letterPainter.paint(canvas, Offset(-letterPainter.width / 2, -letterPainter.height / 2));
      
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}