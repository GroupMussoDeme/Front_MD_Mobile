import 'package:flutter/material.dart';

// --- Définition des couleurs de la Charte Graphique ---

// Couleur principale : Violet (#491B6D)
const Color primaryViolet = Color(0xFF491B6D);

// Couleur secondaire : Violet clair (#EAE1F4)
const Color lightViolet = Color(0xFFEAE1F4);

// Couleur neutre : Blanc (#FFFFFF)
const Color neutralWhite = Colors.white;

// Couleur gris foncé (#707070)
const Color darkGrey = Color(0xFF707070);

// Gradient pour les boutons
const Gradient primaryGradient = LinearGradient(
  colors: [Color(0xFF8A2BE2), primaryViolet],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);
