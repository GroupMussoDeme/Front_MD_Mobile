import 'package:flutter/material.dart';
import 'dart:math' as math;

class CurvedText extends StatelessWidget {
  final String text;
  final double radius;
  final Color color;
  final double textSize;

  const CurvedText({
    super.key,
    required this.text,
    this.radius = 50,
    this.color = const Color(0xFF5A1A82),
    this.textSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(radius * 2, radius * 2),
      painter: CurvedTextPainter(
        text: text,
        radius: radius,
        color: color,
        textSize: textSize,
      ),
    );
  }
}

class CurvedTextPainter extends CustomPainter {
  final String text;
  final double radius;
  final Color color;
  final double textSize;

  CurvedTextPainter({
    required this.text,
    required this.radius,
    required this.color,
    required this.textSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Dessiner chaque caractère le long d'un arc
    final double startAngle = -math.pi; // Commencer à gauche
    final double endAngle = 0; // Finir à droite
    final double angleSpan = endAngle - startAngle;
    final double anglePerChar = angleSpan / (text.length + 1);
    
    for (int i = 0; i < text.length; i++) {
      final String char = text[i];
      
      // Créer un TextPainter pour le caractère
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: char,
          style: TextStyle(
            color: color,
            fontSize: textSize,
            fontWeight: FontWeight.normal,
            fontFamily: 'Poppins',
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      
      textPainter.layout();
      
      // Calculer la position sur l'arc
      final double charAngle = startAngle + (i + 1) * anglePerChar;
      final double x = center.dx + radius * math.cos(charAngle);
      final double y = center.dy + radius * math.sin(charAngle);
      
      // Dessiner le caractère avec rotation appropriée
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(charAngle + math.pi / 2);
      textPainter.paint(canvas, const Offset(-5, -5));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}