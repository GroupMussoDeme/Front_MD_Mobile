import 'package:flutter/material.dart';

class CustomNextButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CustomNextButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white, // Anneau blanc
        ),
        child: Center(
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF491B6D), // Cercle violet foncé
            ),
            child: const Center(
              child: Icon(
                Icons.arrow_forward, // Flèche droite noire
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}